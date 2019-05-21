//
//  EventService.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/13/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct EventService {

	static var shared = EventService()

	var database: Firestore { return Firestore.firestore() }

	func fetchEvent(withId id: String, completion: @escaping (Event?) -> Void) {
		let ref = database.collection("events").document(id)

		ref.getDocument { data, error in
			guard error == nil, let doc = data, doc.exists == true else {
				print(error?.localizedDescription ?? "")
				return
			}

			if let data = data?.data() {
				let event = Event(data: data)

				completion(event)
			}
		}
	}

	func fetchEvents(_ completion: @escaping ([Event]?) -> Void) {
		let ref = database.collection("events")
		var events: [Event] = []

		ref.getDocuments { data, error in
			guard error == nil else {
				print(error?.localizedDescription ?? "")
				return
			}

			for document in data!.documents {
				events.append(Event(data: document.data())!)
			}

			completion(events)
		}
	}

}
