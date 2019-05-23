//
//  FirestoreService.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/22/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Firebase

class FirestoreService: NSObject {

	static let shared = FirestoreService()

	override init() {
		FirebaseApp.configure()
	}
}
