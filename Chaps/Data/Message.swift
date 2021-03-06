//
//  Message.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/20/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import Firebase
import MessageKit
import FirebaseFirestore

struct Message: MessageType {
	var sender: SenderType
	var sentDate: Date
	var kind: MessageKind
	let id: String?
	let content: String
	var downloadURL: URL?
	var image: UIImage? = nil

	var messageId: String {
		return id ?? UUID().uuidString
	}

//	var data: MessageData {
//		if let image = image {
//			return .photo(image)
//		} else {
//			return .text(content)
//		}
//	}

	init(user: User, content: String) {
		sender = ChapUser(senderId: user.uid, displayName: user.displayName ?? "")
		self.content = content
		sentDate = Date()
		id = nil
		kind = .text(content)
	}

	init(user: User, image: UIImage) {
		sender = ChapUser(senderId: user.uid, displayName: user.displayName ?? "")
		self.image = image
		content = ""
		sentDate = Date()
		id = nil
		self.kind = .text("")
	}

	init?(document: QueryDocumentSnapshot) {
		let data = document.data()

		guard let sentDate = data["created"] as? Timestamp else {
			return nil
		}
		guard let senderID = data["senderID"] as? String else {
			return nil
		}
		guard let senderName = data["senderName"] as? String else {
			return nil
		}

		id = document.documentID

		self.sentDate = sentDate.dateValue()
		sender = Sender(senderId: senderID, displayName: senderName)		

		if let content = data["content"] as? String {
			self.content = content
			downloadURL = nil
		} else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
			downloadURL = url
			content = ""
		} else {
			return nil
		}
		kind = .text(content)
	}
}

extension Message: DatabaseRepresentation {

	var representation: [String: Any] {
		var rep: [String: Any] = [
			"created": sentDate,
			"senderID": sender.senderId,
			"senderName": sender.displayName
		]

		if let url = downloadURL {
			rep["url"] = url.absoluteString
		} else {
			rep["content"] = content
		}

		return rep
	}

}

extension Message: Comparable {

	static func == (lhs: Message, rhs: Message) -> Bool {
		return lhs.id == rhs.id
	}

	static func < (lhs: Message, rhs: Message) -> Bool {
		return lhs.sentDate < rhs.sentDate
	}

}
