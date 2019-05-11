//
//  CollectionViewCellNib.swift
//  Chaps
//
//  Created by Joshua Walsh on 5/11/19.
//  Copyright © 2019 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

enum CollectionViewCellNib: String {
  //swiftlint:disable identifier_name
  case GroupCardCollectionViewCell
}

// MARK: UITableView
extension UICollectionView {

  func dequeueReusableCell(withCollectionViewCellNib nib: CollectionViewCellNib,
                           indexPath: IndexPath) -> UICollectionViewCell? {
    return self.dequeueReusableCell(withReuseIdentifier: nib.rawValue, for: indexPath)    
  }

  func registerNibs(_ tableViewCellNibs: Set<CollectionViewCellNib>) {
    tableViewCellNibs.forEach { registerNib($0) }
  }

  func registerNib(_ collectionViewCellNib: CollectionViewCellNib) {
    let nib = UINib(collectionViewCellNib: collectionViewCellNib)
    register(nib, forCellWithReuseIdentifier: collectionViewCellNib.rawValue)
  }
}

// MARK: UINib
fileprivate extension UINib {

  convenience init(collectionViewCellNib: CollectionViewCellNib) {
    self.init(nibName: collectionViewCellNib.rawValue, bundle: nil)
  }
}
