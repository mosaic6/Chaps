//
//  Group.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/10/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation

struct Group: Codable {

  let name: String
  let userCount: Int
  let groupImage: String? // Or a URL?
  let description: String?
}
