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

	var messageId: String {
		return id ?? UUID().uuidString
	}

	init?(document: QueryDocumentSnapshot) {
		let data = document.data()

		guard let sentDate = data["created"] as? Date else {
			return nil
		}
		guard let senderID = data["senderID"] as? String else {
			return nil
		}
		guard let senderName = data["senderName"] as? String else {
			return nil
		}

		id = document.documentID

		self.sentDate = sentDate
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