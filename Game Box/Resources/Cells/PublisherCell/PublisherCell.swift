//
//  PublisherCell.swift
//  Game Box
//
//  Created by alihizardere on 24.05.2024.
//

import UIKit

class PublisherCell: UICollectionViewCell {
  
  @IBOutlet weak var publisherName: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    layer.backgroundColor = UIColor.black.cgColor
    layer.borderWidth = 2
    layer.borderColor = UIColor.lightGray.cgColor
    layer.cornerRadius = 10
  }
  
}
