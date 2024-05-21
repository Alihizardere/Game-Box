//
//  UICollectionView.swift
//  Game Box
//
//  Created by alihizardere on 20.05.2024.
//

import UIKit

extension UICollectionView {
  
  func register(cellType: UICollectionViewCell.Type) {
    register(cellType.nib, forCellWithReuseIdentifier: cellType.identifier)
  }

  func dequeCell<T: UICollectionViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? T else {
      fatalError("deque cell error")  }
    return cell
  }
}
