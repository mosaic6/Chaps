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
  let author: String?


	init(name: String, createdAt: Timestamp, author: String) {
		id = nil
		self.name = name
		self.userCount = 1
		self.groupImage = nil
		self.description = nil
		self.createdAt = createdAt
		self.author = author
	}

  init?(document: QueryDocumentSnapshot) {
		let data = document.data()
    //swiftlint:disable force_cast
		guard let name = data["name"] as? String,
			let createdAt = data["createdAt"] as? Timestamp,
			let userCount = data["userCount"] as? Int else { return nil }

		self.id = document.documentID
		self.name = name
		self.createdAt = createdAt
		self.userCount = userCount
		self.groupImage = nil
		self.author = nil
		self.description = nil
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
