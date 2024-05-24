//
//  FavoriteCell.swift
//  Game Box
//
//  Created by alihizardere on 24.05.2024.
//

import UIKit

class FavoriteCell: UITableViewCell {

  // MARK: - Properties
  static let identifier = "FavoriteCell"
  @IBOutlet weak var gameImage: UIImageView!
  @IBOutlet weak var gameName: UILabel!
  @IBOutlet weak var gameRating: UILabel!

  // MARK: - Lifecycle
  override func awakeFromNib() {
    super.awakeFromNib()
    gameImage.layer.cornerRadius = 10
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  // MARK: - Functions
  func configure(game: GameEntity){
    gameName.text = game.name
    gameRating.text = "\(game.rating)"
    guard let imageURL = URL(string: game.backgroundImageURL ?? "") else { return }
    gameImage.kf.setImage(with: imageURL)
  }
}
