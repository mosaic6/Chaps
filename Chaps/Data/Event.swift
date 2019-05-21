//
//  Event.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/16/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Event {
	let name: String
	let description: String?
	let eventImage: String?
	let eventDate: Timestamp
	let author: String
	let createdAt: Timestamp
	let userCount: Int

	init?(data: [String: Any]) {
		//swiftlint:disable force_cast
		self.name = data["name"] as! String
		self.userCount = data["userCount"] as! Int
		self.eventImage = data["eventImage"] as? String
		self.description = data["description"] as? String
		self.createdAt = data["createdAt"] as! Timestamp
		self.author = data["author"] as! String
		self.eventDate = data["eventDate"] as! Timestamp
	}
}
