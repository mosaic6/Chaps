//
//  Array.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation

extension Array {

  public subscript(safe index: Int) -> Element? {
    get {
      return index >= 0 && index < self.count ? self[index] : nil
    }
    set {
      if let newValue = newValue, index >= 0, index < self.count {
        self[index] = newValue
      }
    }
  }
}
