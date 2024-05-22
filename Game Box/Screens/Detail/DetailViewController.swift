//
//  DetailViewController.swift
//  Game Box
//
//  Created by alihizardere on 20.05.2024.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
  // MARK: - Properties
  var selectedGame: GameDetail?
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var gameImage: UIImageView!
  @IBOutlet weak var gameNameLabel: UILabel!
  

// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      configureSelectedInfo()
      gameImage.layer.cornerRadius = 20
      gameImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
      navigationController?.isNavigationBarHidden = false
    }

  private func configureSelectedInfo(){
    guard let game = selectedGame else { return }
    print(game.backgroundImage ?? "sss")
    if let url = URL(string: game.backgroundImage ?? "") {
      backgroundImage.kf.setImage(with: url)
      gameImage.kf.setImage(with: url)
    }
    gameNameLabel.text = game.name
  }

}
