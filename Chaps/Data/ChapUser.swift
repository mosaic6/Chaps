//
//  User.swift
//  Chaps
//
//  Created by Joshua Walsh on 6/26/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import MessageKit

struct ChapUser: SenderType, Equatable {
	var senderId: String
	var displayName: String
}
