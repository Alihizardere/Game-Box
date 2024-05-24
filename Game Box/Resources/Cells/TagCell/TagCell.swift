//
//  TagCell.swift
//  Game Box
//
//  Created by alihizardere on 24.05.2024.
//

import UIKit

class TagCell: UICollectionViewCell {

  @IBOutlet weak var tagTitle: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.borderWidth = 1
    layer.borderColor = UIColor.lightGray.cgColor
    layer.cornerRadius = 10
  }
}