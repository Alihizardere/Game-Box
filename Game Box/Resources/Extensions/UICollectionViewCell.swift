//
//  UICollectionViewCell.swift
//  Game Box
//
//  Created by alihizardere on 20.05.2024.
//

import UIKit

extension UICollectionViewCell {
  
  static var identifier: String {
    return String(describing: self)
  }

  static var nib: UINib {
    return UINib(nibName: identifier, bundle: nil)
  }
}
