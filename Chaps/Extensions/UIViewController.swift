//
//  UIViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

  @objc func disableView() {
    self.view.isUserInteractionEnabled = false
  }

  @objc func enableView() {
    self.view.isUserInteractionEnabled = true
  }
}

extension UIViewController {

  class var currentlyShown: UIViewController? {
    if let rootViewController = UIViewController.root {
      return UIViewController.findCurrentlyShownViewController(baseViewController: rootViewController)
    }
    return nil
  }

  class var root: UIViewController? {
    return UIApplication.shared.keyWindow?.rootViewController
  }

}

// MARK: Access control helpers
extension UIViewController {

  class func accessControlledDestinationForDestination(_ destination: UIViewController) -> UIViewController {
    guard let _ = UIViewController.accessControlActionForViewController(destination) else {
      return destination
    }

    return destination
  }

  private class func accessControlActionForViewController(_ viewController: UIViewController) -> AccessControl.Action? {
    let viewControllerToCheckForAccessControl = viewController.firstViewController

    if viewControllerToCheckForAccessControl != viewController {
      return UIViewController.accessControlActionForViewController(viewControllerToCheckForAccessControl)
    }

    return (viewController as? AccessControllable)?.accessControlAction
  }
}

// MARK: View Hierarchy Traversal Helpers
extension UIViewController {

  class func presentOnCurrentlyShownViewController(viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
    guard let currentlyShownViewController = UIViewController.currentlyShown else {
      return
    }
    currentlyShownViewController.present(viewController, animated: animated, completion: completion)
  }

  class func findCurrentlyShownViewController(baseViewController: UIViewController) -> UIViewController? {
    if let presentedViewController = baseViewController.presentedViewController {
      return UIViewController.findCurrentlyShownViewController(baseViewController: presentedViewController)
    }

    if let navViewController = baseViewController as? UINavigationController, let topVC = navViewController.topViewController {
      return UIViewController.findCurrentlyShownViewController(baseViewController: topVC)
    }

    if let tabViewController = baseViewController as? UITabBarController, let selectedTabVC = tabViewController.selectedViewController {
      return UIViewController.findCurrentlyShownViewController(baseViewController: selectedTabVC)
    }

    return baseViewController
  }

}

// MARK: UI Helpers
extension UIViewController {

  @objc var navigationBarColor: UIColor {
    return NavigationController.defaultNavigationBarColor
  }
}

// MARK: Navigation controller helpers
private extension UIViewController {

  var allViewControllers: [UIViewController] {
    return self.navigationController?.allViewControllers ?? [self]
  }

  var firstViewController: UIViewController {
    return self.allViewControllers.first ?? self
  }

  class func containsViewControllerInNavigationStack(_ viewController: UIViewController) -> Bool {
    guard let currentViewController = UIViewController.currentlyShown else {
      return false
    }

    for navStackViewController in currentViewController.allViewControllers {
      if type(of: navStackViewController) === type(of: viewController.firstViewController) {
        return true
      }
    }

    return false
  }

}
