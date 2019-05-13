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

  let name: String
  let userCount: Int
  let groupImage: String? // Or a URL?
  let description: String?
  let createdAt: Timestamp
  let author: String

  init?(data: [String: Any]) {
    //swiftlint:disable force_cast
    self.name = data["name"] as! String
    self.userCount = data["userCount"] as! Int
    self.groupImage = data["groupImage"] as? String
    self.description = data["description"] as? String
    self.createdAt = data["createdAt"] as! Timestamp
    self.author = data["author"] as! String
  }
}
