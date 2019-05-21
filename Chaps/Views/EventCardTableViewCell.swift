//
//  EventCardTableViewCell.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/16/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit
import FirebaseFirestore

class EventCardTableViewCell: UITableViewCell {
	
	@IBOutlet weak var mainBackgroundView: UIView!
	@IBOutlet weak var eventNameLabel: UILabel!
	@IBOutlet weak var eventDateLabel: UILabel!
	@IBOutlet weak var eventImageView: UIImageView!
	
	override var frame: CGRect {
		get {
			return super.frame
		}
		set (newFrame) {
			let inset: CGFloat = 20
			var frame = newFrame
			frame.origin.x += inset
			frame.size.width -= 2 * inset
			frame.size.height = 80
			super.frame = frame
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		self.configureMainBackgroundView()
	}

	func configureMainBackgroundView() {
		self.mainBackgroundView.layer.cornerRadius = 15
		self.mainBackgroundView.layer.masksToBounds = true
		self.mainBackgroundView.layer.borderWidth = 1
		self.mainBackgroundView.layer.borderColor = UIColor.clear.cgColor

		self.layer.shadowOpacity = 0.18
		self.layer.shadowOffset = CGSize(width: 0, height: 2)
		self.layer.shadowRadius = 2
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.masksToBounds = false
	}
	
	func configureCell(event: Event) {
		self.eventNameLabel.text = event.name
//		self.eventDateLabel.text =
	}

	func formatDate(date: Timestamp) -> String {
		return ""
	}
	
}