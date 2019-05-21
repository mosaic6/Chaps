//
//  GroupService.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/12/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct GroupService {

  static var shared = GroupService()

  var database: Firestore { return Firestore.firestore() }

  func fetchGroup(withId id: String, completion: @escaping (Group?) -> Void) {
    let ref = database.collection("groups").document(id)

    ref.getDocument { data, error in
      guard error == nil, let doc = data, doc.exists == true else {
        print(error?.localizedDescription ?? "")
        return
      }

      if let data = data?.data() {
        let group = Group(data: data)

        completion(group)
      }
    }
  }

  func fetchGroups(_ completion: @escaping ([Group]?) -> Void) {
    let ref = database.collection("groups")
    var groups: [Group] = []

    ref.getDocuments { data, error in
      guard error == nil else {
        print(error?.localizedDescription ?? "")
        return
      }

      for document in data!.documents {
        groups.append(Group(data: document.data())!)
      }

      completion(groups)
    }
  }

}
