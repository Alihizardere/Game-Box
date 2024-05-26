//
//  ScreenShotCell.swift
//  Game Box
//
//  Created by alihizardere on 24.05.2024.
//

import UIKit
import Kingfisher

class ScreenShotCell: UICollectionViewCell {

  @IBOutlet weak var gameScreenShot: UIImageView!

  override func awakeFromNib() {
        super.awakeFromNib()
    }

  func configure(screenShot: String){
    guard let url = URL(string: screenShot) else { return }
    gameScreenShot.kf.setImage(with: url)
  }
}
