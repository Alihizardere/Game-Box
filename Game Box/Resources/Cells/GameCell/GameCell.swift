//
//  GameCell.swift
//  Game Box
//
//  Created by alihizardere on 19.05.2024.
//

import UIKit
import Kingfisher

class GameCell: UICollectionViewCell {

  // MARK: - Properties
  static let identifier = "GameCell"
  @IBOutlet weak var gameImageView: UIImageView!
  @IBOutlet weak var gameName: UILabel!
  @IBOutlet weak var gameRating: UILabel!

  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  // MARK: - Functions
  func setup(game: Game){
    gameName.text = game.name
    gameRating.text = "\(game.rating ?? 0.0)"
    guard let imageUrl = URL(string: game.backgroundImage ?? "") else { return }
    gameImageView.kf.setImage(with: imageUrl)
  }
}
