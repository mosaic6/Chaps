//
//  ViewRoutes.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import SafariServices

struct ViewRoutes {

  enum PresentationStyle: Equatable {
    case presentOnCurrentlyShown
    case push(overViewController: UIViewController)

    var hashString: String {
      switch self {
      case .presentOnCurrentlyShown:
        return "presentOnCurrentlyShown"
      case .push:
        return "push"
      }
    }

    static func == (lhs: PresentationStyle, rhs: PresentationStyle) -> Bool {
      return lhs.hashString == rhs.hashString
    }
  }

  // MARK: Lifecycle

  private init() {}

  // MARK: Static Methods

  static func goToRoute(_ route: Route, presentationStyle: PresentationStyle = .presentOnCurrentlyShown, animated: Bool = true, callback: ((EmptyResult) -> Void)? = nil) {

    if ViewRoutes.isDisplaying(route: route) {
      callback?(.failure)
      return
    }

    route.createViewController { result in
      switch result {
      case .success(let destination):
        let (preparedViewController, preparedPresentationStyle) = route.prepareViewControllerForPresentation(viewController: destination, presentationStyle: presentationStyle)

        switch preparedPresentationStyle {
        case .presentOnCurrentlyShown:
          UIViewController.presentOnCurrentlyShownViewController(viewController: preparedViewController, animated: animated) {
            callback?(.success)
          }

        case .push(let viewController):
          viewController.navigationController?.pushViewController(preparedViewController, animated: animated)
          callback?(.success)
        }

      case .failure:
        callback?(.failure)

      }
    }

  }

  static func isDisplaying(route: Route) -> Bool {
    if let currentRoute = UIViewController.currentlyShown as? Routable {
      return currentRoute.isEqual(to: route)
    }
    return false
  }
}

protocol Routable {
  func isEqual(to route: Route) -> Bool
}

enum Route {
  case mainView
  case login
  case verificationCode

  fileprivate func createViewController(_ callback: @escaping (Result<UIViewController, Error>) -> Void) {
    switch self {
    case .mainView:
      let mainViewController = ViewController.mainViewController
      callback(.success(mainViewController))
    case .login:
      let loginViewController = ViewController.loginViewController
      callback(.success(loginViewController))
    case .verificationCode:
      let verificationCodeViewController = ViewController.verificationCodeViewController
      callback(.success(verificationCodeViewController))
    }
  }

  fileprivate func prepareViewControllerForPresentation(viewController: UIViewController,
                                                        presentationStyle: ViewRoutes.PresentationStyle) ->
    (preparedViewController: UIViewController, preparedPresentationStyle: ViewRoutes.PresentationStyle) {
    var preparedViewController = UIViewController.accessControlledDestinationForDestination(viewController)

    let preparedPresentationStyle: ViewRoutes.PresentationStyle = preparedViewController == viewController ? presentationStyle : .presentOnCurrentlyShown

    switch preparedPresentationStyle {
    case .presentOnCurrentlyShown:
      if !(preparedViewController is UINavigationController) {
        preparedViewController = NavigationController(preparedViewController)
      }

    case .push:
      break
    }

    if viewController is SFSafariViewController {
      preparedViewController = viewController
    }

    return (preparedViewController, preparedPresentationStyle)
  }
}
