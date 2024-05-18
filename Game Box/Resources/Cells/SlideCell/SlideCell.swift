//
//  SlideCell.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

import UIKit

class SlideCell: UICollectionViewCell {

  // MARK: -  Properties
  static let identifier = "SlideCell"
  @IBOutlet weak var slideImageView: UIImageView!

  // MARK: - Lifecycle
  override func awakeFromNib() {
        super.awakeFromNib()
  }
}
