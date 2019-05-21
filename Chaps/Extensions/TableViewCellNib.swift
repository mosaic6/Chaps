//
//  TableViewCellNib.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

enum TableViewCellNib: String {
  //swiftlint:disable identifier_name
  case genericTextEntryTableViewCell
  case GroupCardTableViewCell
	case EventCardTableViewCell
}

// MARK: UITableView
extension UITableView {

  func dequeueReusableCell(withTableViewCellNib nib: TableViewCellNib) -> UITableViewCell? {
    return self.dequeueReusableCell(withIdentifier: nib.rawValue)
  }

  func registerNibs(_ tableViewCellNibs: Set<TableViewCellNib>) {
    tableViewCellNibs.forEach { registerNib($0) }
  }

  func registerNib(_ tableViewCellNib: TableViewCellNib) {
    let nib = UINib(tableViewCellNib: tableViewCellNib)
    register(nib, forCellReuseIdentifier: tableViewCellNib.rawValue)
  }
}

// MARK: UINib
fileprivate extension UINib {

  convenience init(tableViewCellNib: TableViewCellNib) {
    self.init(nibName: tableViewCellNib.rawValue, bundle: nil)
  }
}
