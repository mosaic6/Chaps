//
//  Storyboard.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

// MARK: Storyboard
struct Storyboard {

  static var main: UIStoryboard {
    return UIStoryboard(storyboardIdentifier: .main)
  }

}

// MARK: StoryboardIdentifier
fileprivate enum StoryboardIdentifier: String {
  case main
}

// MARK: Helpers
fileprivate extension UIStoryboard {
  convenience init(storyboardIdentifier: StoryboardIdentifier) {
    self.init(name: storyboardIdentifier.rawValue, bundle: nil)
  }
}
