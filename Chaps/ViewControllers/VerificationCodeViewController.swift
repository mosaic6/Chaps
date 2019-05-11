//
//  VerificationCodeViewController.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/10/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import Firebase

class VerificationCodeViewController: UIViewController {

  // MARK: Outlets

  @IBOutlet weak var verificationCodeTextField: UITextField!
  @IBOutlet weak var verifyButton: RoundButton!

  // MARK: Actions

  @IBAction func verifyAndSignIn(_ sender: Any) {
    guard let verificationCode = verificationCodeTextField.text else { return }

    self.verifyButton.loadingIndicator(true)
    signInWithVerificationCode(verificationCode: verificationCode)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

  }

  func signInWithVerificationCode(verificationCode: String) {
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")!
    let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID,
                                                             verificationCode: verificationCode)

    Auth.auth().signInAndRetrieveData(with: credential) { _, error in
      if let _ = error {
        self.verifyButton.loadingIndicator(false)
        return
      }

      self.dismiss(animated: true, completion: nil)
    }
  }

}
