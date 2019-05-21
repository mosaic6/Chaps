//
//  NewEventViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/15/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewEventViewController: UIViewController {

	// MARK: Variables

	let database = Firestore.firestore()
	var ref: DocumentReference?

	// MARK: Outlets

	@IBOutlet weak var eventNameTextField: UITextField!
	@IBOutlet weak var eventDescriptionTextField: UITextField!
	@IBOutlet weak var eventDatePicker: UIDatePicker!
	
	// MARK: Actions

	@IBAction func dismissView(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func saveEvent(_ sender: Any) {
		self.saveNewEvent()
	}

	override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

	// MARK: Saving group

	private func saveNewEvent() {
		guard let eventName = self.eventNameTextField.text, !eventName.isEmpty else { return }

		let description = self.eventDescriptionTextField.text ?? ""

		guard let userId = Auth.auth().currentUser?.uid else { return }

		let data: [String: Any?] = ["name": eventName,
																"userCount": 1,
																"eventImage": nil,
																"description": description,
																"author": userId,
																"eventDate": eventDatePicker.date,
																"createdAt": Date()]

		ref = database.collection("events").addDocument(data: data) { err in
			if err == nil {
				self.dismiss(animated: true, completion: nil)
			}
		}
	}

}
