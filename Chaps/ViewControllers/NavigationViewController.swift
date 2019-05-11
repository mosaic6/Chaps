//
//  NavigationViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {

  // MARK: Static variables

  static var defaultNavigationBarColor: UIColor {
    return .lightGray
  }

  // MARK: Variables

  var barTintColor: UIColor = NavigationController.defaultNavigationBarColor {
    didSet {
      if self.barTintColor != oldValue {
        self.updateFromBarTintColor()
      }
    }
  }

  private var isFirstLoad = true

  // MARK: UINavigationController overrides

  override func viewDidLoad() {
    super.viewDidLoad()

    self.configure()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    if self.isFirstLoad {
      self.updateBarTintColor(topViewController: self.topViewController)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.isFirstLoad = false
  }

  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    self.viewControllers.last?.navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    super.pushViewController(viewController, animated: animated)
  }

  override func popViewController(animated: Bool) -> UIViewController? {
    let poppedVC = super.popViewController(animated: animated)
    self.updateBarTintColor(topViewController: self.topViewController)
    return poppedVC
  }
}

// MARK: Configuration
private extension NavigationController {

  func configure() {
    self.delegate = self
    self.updateFromBarTintColor()
  }
}

// MARK: UI Updating
private extension NavigationController {

  func updateFromBarTintColor() {
    self.navigationBar.barTintColor = self.barTintColor
  }

  func updateBarTintColor(topViewController: UIViewController?) {
    self.barTintColor = topViewController?.navigationBarColor ?? NavigationController.defaultNavigationBarColor
  }
}

// MARK: Public Convenience Functions
extension NavigationController {

  func updateBarTintColor() {
    self.updateBarTintColor(topViewController: self.topViewController)
  }

}

// MARK: - Protocol conformance -
// MARK: UINavigationControllerDelegate
extension NavigationController: UINavigationControllerDelegate {

  func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    self.transitionCoordinator?.animate(alongsideTransition: { _ in
      self.updateBarTintColor(topViewController: self.topViewController)
    }, completion: nil)

    self.transitionCoordinator?.notifyWhenInteractionChanges { context in
      if context.isCancelled, let startingViewController = context.viewController(forKey: .from) {
        self.updateBarTintColor(topViewController: startingViewController)
      }
    }
  }
}
