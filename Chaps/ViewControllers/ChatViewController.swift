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

	private let db = Firestore.firestore()
	private var reference: CollectionReference?
	private var messageListener: ListenerRegistration?
	private let user: User?
	private let group: Group

	let sender = Sender(id: "", displayName: "")
	var messages: [MessageType] = []

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

		guard let id = group.id else {
			navigationController?.popViewController(animated: true)
			return
		}

		reference = db.collection(["groups", id, "thread"].joined(separator: "/"))

		messageListener = reference?.addSnapshotListener { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
				return
			}

			snapshot.documentChanges.forEach { change in
				self.handleDocumentChange(change)
			}
		}

		messageInputBar.leftStackView.alignment = .center
		messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
//		messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false) // 3
	}

	// MARK: Helper

	private func save(_ message: Message) {
		reference?.addDocument(data: message.representation) { error in
			if let e = error {
				print("Error sending message: \(e.localizedDescription)")
				return
			}

			self.messagesCollectionView.scrollToBottom()
		}
	}

	private func insertNewMessage(_ message: Message) {
//		guard !messages.contains(message) else { return }

		messages.append(message)
//		messages.sort()

		let isLatestMessage = messages.index(after: 1) == messages.count - 1
//		let isLatestMessage = messages.index(of: message) == (messages.count - 1)
		let shouldScrollToBottom = messagesCollectionView.scrollsToTop && isLatestMessage

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
//
//	private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
//		let ref = Storage.storage().reference(forURL: url.absoluteString)
//		let megaByte = Int64(1 * 1024 * 1024)
//
//		ref.getData(maxSize: megaByte) { data, error in
//			guard let imageData = data else {
//				completion(nil)
//				return
//			}
//
//			completion(UIImage(data: imageData))
//		}
//	}
}

extension ChatViewController: MessagesDataSource {
	func currentSender() -> SenderType {
		return Sender(id: "123", displayName: "Josh")
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

	func messageInputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
		guard let user = self.user else { return }
		let message = Message(user: user, content: text)

		save(message)
		inputBar.inputTextView.text = ""
	}

}
