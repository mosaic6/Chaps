//
//  ViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

struct ViewController {

  static var mainViewController: MainViewController {
    return ViewControllerIdentifier.mainViewController.create()
  }

  static var loginViewController: LoginViewController {
    return ViewControllerIdentifier.loginViewController.create()
  }

  static var verificationCodeViewController: VerificationCodeViewController {
    return ViewControllerIdentifier.verificationCodeViewController.create()
  }

}

// MARK: - Other type declarations -
// MARK: ViewControllerIdentifier
private enum ViewControllerIdentifier: String {
  case mainViewController
  case loginViewController
  case verificationCodeViewController
}

private extension ViewControllerIdentifier {

  func create<T: UIViewController>() -> T {
    //swiftlint:disable force_cast
    return UIStoryboard(name: self.storyboardIdentifier.rawValue, bundle: nil).instantiateViewController(withIdentifier: self.rawValue) as! T
  }

  private var storyboardIdentifier: StoryboardIdentifier {
    switch self {
    case .mainViewController:
      return .main
    case .loginViewController:
      return .main
    case .verificationCodeViewController:
      return .main
    }
  }
}

// MARK: Storyboard
private enum StoryboardIdentifier: String {
  case main
}

// MARK: UIStoryboard
fileprivate extension UIStoryboard {

  func initialViewController<T: UIViewController>() -> T {
    //swiftlint:disable force_cast
    return self.instantiateInitialViewController() as! T
  }

  func viewControllerWithIdentifier<T: UIViewController>(_ viewControllerIdentifier: ViewControllerIdentifier) -> T {
    //swiftlint:disable force_cast
    return self.instantiateViewController(withIdentifier: viewControllerIdentifier.rawValue) as! T
  }
}
