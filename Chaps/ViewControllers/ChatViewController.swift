//
//  ChatViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/20/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import Photos
import Firebase
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {

	private var isSendingPhoto = false {
		didSet {
			DispatchQueue.main.async {
				self.messageInputBar.leftStackViewItems.forEach { item in
//					item.isEnabled = !self.isSendingPhoto
				}
			}
		}
	}

	private let db = Firestore.firestore()
	private var reference: CollectionReference?
	private var messageListener: ListenerRegistration?
	private let user: User?
	private let group: Group
	private let storage = Storage.storage().reference()

	var messages: [Message] = []

	init?(user: User, group: Group) {
		self.user = user
		self.group = group
		super.init(nibName: nil, bundle: nil)

		title = group.name
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		messageInputBar.delegate = self
		messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesLayoutDelegate = self
		messagesCollectionView.messagesDisplayDelegate = self

//		guard !group.id!.isEmpty else {
//			navigationController?.popViewController(animated: true)
//			return
//		}

		reference = db.collection(["groups", group.id!, "thread"].joined(separator: "/"))

		db.collection("groups").getDocuments { documentSnapshot, error in
			for document in documentSnapshot?.documents ?? [] {
				print(document.documentID)
			}
		}


		messageListener = reference?.addSnapshotListener { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error listening for group thread updates: \(error?.localizedDescription ?? "No error")")
				return
			}

			snapshot.documentChanges.forEach { change in
				self.handleDocumentChange(change)
			}
		}

		let cameraItem = InputBarButtonItem(type: .system)
		cameraItem.tintColor = .primary
		cameraItem.setTitle("📷", for: .normal)
		cameraItem.addTarget(
			self,
			action: #selector(cameraButtonPressed),
			for: .primaryActionTriggered
		)
		cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)

		messageInputBar.leftStackView.alignment = .center
		messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
		messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false) // 3
	}

	// MARK: - Actions

	@objc private func cameraButtonPressed() {
		let picker = UIImagePickerController()
		picker.delegate = self

		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		} else {
			picker.sourceType = .photoLibrary
		}

		present(picker, animated: true, completion: nil)
	}

	// MARK: Helper

	private func save(_ message: Message) {
		reference?.document().setData(message.representation) { error in
			if let e = error {
				print("Error sending message: \(e.localizedDescription)")
				return
			}

			self.messagesCollectionView.scrollToBottom()
		}
	}

	private func insertNewMessage(_ message: Message) {
		messages.append(message)

		messages.sort()

//		let isLatestMessage = messages.index(of: message) == (messages.count - 1)
		let shouldScrollToBottom = messagesCollectionView.scrollsToTop

		messagesCollectionView.reloadData()

		if shouldScrollToBottom {
			DispatchQueue.main.async {
				self.messagesCollectionView.scrollToBottom(animated: true)
			}
		}
	}

	private func handleDocumentChange(_ change: DocumentChange) {
		guard let message = Message(document: change.document) else {
			return
		}

		switch change.type {
		case .added:
			insertNewMessage(message)
		case .modified, .removed:
			return
		}
	}

	private func sendPhoto(_ image: UIImage) {
		isSendingPhoto = true

		uploadImage(image, to: group) { [weak self] url in
			guard let `self` = self else {
				return
			}
			self.isSendingPhoto = false

			guard let url = url else {
				return
			}

			var message = Message(user: self.user!, image: image)
			message.downloadURL = url

			self.save(message)
			self.messagesCollectionView.scrollToBottom()
		}
	}

	private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
		let ref = Storage.storage().reference(forURL: url.absoluteString)
		let megaByte = Int64(1 * 1024 * 1024)

		ref.getData(maxSize: megaByte) { data, error in
			guard let imageData = data else {
				completion(nil)
				return
			}

			completion(UIImage(data: imageData))
		}
	}

	private func uploadImage(_ image: UIImage, to group: Group, completion: @escaping (URL?) -> Void) {
		guard let groupID = group.id else {
			completion(nil)
			return
		}

		guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
			completion(nil)
			return
		}

		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"

		let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
		storage.child(groupID).child(imageName).putData(data, metadata: metadata) { meta, error in
			completion(URL(string: meta?.path ?? ""))
		}
	}
}

extension ChatViewController: MessagesDataSource {
	func currentSender() -> SenderType {
		return ChapUser(senderId: user?.uid ?? "", displayName: user?.displayName ?? "")
	}

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.section]
	}

	func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}

}

extension ChatViewController: MessagesDisplayDelegate {

}

extension ChatViewController: MessagesLayoutDelegate {

}

// MARK: - MessageInputBarDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {

	func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		guard let user = self.user else { return }
		let message = Message(user: user, content: text)

		save(message)
		inputBar.inputTextView.text = ""
	}

}

// MARK: - UIImagePickerControllerDelegate

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		picker.dismiss(animated: true, completion: nil)

		if let asset = info[.phAsset] as? PHAsset { // 1
			let size = CGSize(width: 500, height: 500)
			PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFit, options: nil) { result, info in
				guard let image = result else {
					return
				}

				self.sendPhoto(image)
			}
		} else if let image = info[.originalImage] as? UIImage { // 2
			sendPhoto(image)
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: nil)
	}

}
