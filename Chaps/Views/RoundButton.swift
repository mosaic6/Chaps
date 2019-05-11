//
//  RoundButton.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/10/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

  // MARK: IBInspectables

  @IBInspectable var cornerRadius: CGFloat = 0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = cornerRadius > 0
    }
  }

  @IBInspectable var borderWidth: CGFloat = 0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }

  @IBInspectable var borderColor: UIColor? {
    didSet {
      layer.borderColor = borderColor?.cgColor
    }
  }  

  // MARK: Overrides

  override var isHighlighted: Bool {
    didSet {
      if oldValue != isHighlighted {
        updateAppearance()
      }
    }
  }

  // MARK: Appearance

  private func updateAppearance() {
    if (isSelected || isHighlighted) && isEnabled {
      buttonTouchedIn()
    } else {
      buttonTouchedOut()
    }
    alpha = isEnabled ? 1 : 0.8
  }

  private func buttonTouchedIn() {
    self.setTitle("", for: .normal)
  }

  private func buttonTouchedOut() {
    self.setTitle("", for: .normal)
  }
}

extension UIButton {
  func loadingIndicator(_ show: Bool) {
    let tag = 808404
    if show {
      self.isEnabled = false
      self.alpha = 0.5
      let indicator = UIActivityIndicatorView()
      let buttonHeight = self.bounds.size.height
      let buttonWidth = self.bounds.size.width
      indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
      indicator.tag = tag
      self.addSubview(indicator)
      indicator.startAnimating()
    } else {
      self.isEnabled = true
      self.alpha = 1.0
      if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
        indicator.stopAnimating()
        indicator.removeFromSuperview()
      }
    }
  }
}
