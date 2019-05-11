//
//  LoginViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/9/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import PromiseKit

class LoginViewController: UIViewController {

  // MARK: Outlets

  @IBOutlet weak var phoneNumberTextField: UITextField!
  @IBOutlet weak var signInButton: RoundButton!

  // MARK: Actions

  @IBAction func signIn(_ sender: Any) {
    phoneLogin()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.navigationController?.navigationBar.isHidden = true
  }

  func phoneLogin() {
    self.signInButton.loadingIndicator(true)

    guard let phoneNumber = phoneNumberTextField.text else { return }

    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationId, _ in
      guard let verificationId = verificationId else {
        self.signInButton.loadingIndicator(false)
        return
      }

      UserDefaults.standard.set(verificationId, forKey: "authVerificationID")

      self.performSegue(withIdentifier: "verificationCode", sender: nil)
    }
  }

}
