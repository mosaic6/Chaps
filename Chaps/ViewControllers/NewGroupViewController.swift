//
//  NewGroupViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewGroupViewController: UIViewController {

  // MARK: Variables

  let database = Firestore.firestore()
  var ref: DocumentReference?

  // MARK: Outlets

  @IBOutlet weak var groupNameTextField: UITextField!

  // MARK: Actions

  @IBAction func saveNewGroup(_ sender: Any) {
    saveNewGroup()
  }

  @IBAction func closeView(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

//    self.groupNameTextField.becomeFirstResponder()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: Saving group

  private func saveNewGroup() {
    guard let groupName = self.groupNameTextField.text, !groupName.isEmpty else { return }

    guard let userId = Auth.auth().currentUser?.uid else { return }

    let data: [String: Any?] = ["name": groupName,
                                "userCount": 1,
                                "groupImage": nil,
                                "description": nil,
                                "author": userId,
                                "createdAt": Date()]

    ref = database.collection("groups").addDocument(data: data) { err in
      if err == nil {
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
}
