//
//  GenericTextEntryTableViewCell.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import UIKit

class GenericTextEntryTableViewCell: UITableViewCell {

  @IBOutlet weak var textEntryField: UITextField!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
