//
//  AccessControl.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit

protocol AccessControllable: class {
  var accessControlAction: AccessControl.Action? { get }
}

class AccessControl {

  // MARK: Static Variables

  static var statusResults: [Action: StatusResult] = [:]

  static let enabled = AccessControl.StatusResult.known(.enabled)
}

// MARK: Helpers
extension AccessControl {

  static func doesAnyActionHaveStatus(_ accessControlStatus: AccessControl.Status) -> Bool {
    return AccessControl.statusResults.values.contains { $0.rawStatus == accessControlStatus.rawValue }
  }
}

// MARK: - Members -
// MARK: Status Result
extension AccessControl {

  enum StatusResult {
    case known(AccessControl.Status)
    case unknown(String)

    var isEnabled: Bool {
      switch self {
      case let .known(status):
        return status == .enabled
      case .unknown:
        return false
      }
    }

    var rawStatus: String {
      switch self {
      case let .known(status):
        return status.rawValue
      case let .unknown(unknownStatus):
        return unknownStatus
      }
    }
  }
}

// MARK: Status
extension AccessControl {

  enum Status: String {
    case enabled = "ENABLED"
  }
}

// MARK: Action
extension AccessControl {

  enum Action: String {
    case global = "viewAccount"

    case updateCredentials
  }
}
