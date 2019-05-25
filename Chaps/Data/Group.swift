//
//  Group.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/10/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Group {

	let id: String?
  let name: String
  let userCount: Int
  let groupImage: String? // Or a URL?
  let description: String?
  let createdAt: Timestamp
  let author: String
	let messages: [Message]?


  init?(document: QueryDocumentSnapshot) {
		let data = document.data()
    //swiftlint:disable force_cast
		self.id = data["id"] as? String
    self.name = data["name"] as! String
    self.userCount = data["userCount"] as! Int
    self.groupImage = data["groupImage"] as? String
    self.description = data["description"] as? String
    self.createdAt = data["createdAt"] as! Timestamp
    self.author = data["author"] as! String
		self.messages = data["messages"] as? [Message]
  }
}
extension Group: DatabaseRepresentation {

	var representation: [String: Any] {
		var rep = ["name": name]

		if let id = id {
			rep["id"] = id
		}

		return rep
	}
}

extension Group: Comparable {

	static func == (lhs: Group, rhs: Group) -> Bool {
		return lhs.id == rhs.id
	}

	static func < (lhs: Group, rhs: Group) -> Bool {
		return lhs.name < rhs.name
	}

}
