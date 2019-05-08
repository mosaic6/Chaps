//
//  Location.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/5/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import CoreLocation

struct Location {
  let location: CLLocation

  init(location: CLLocation) {
    self.location = location    
  }
}