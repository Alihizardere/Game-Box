//
//  DetailViewController.swift
//  Game Box
//
//  Created by alihizardere on 20.05.2024.
//

import UIKit

class DetailViewController: UIViewController {
  // MARK: - Properties
  var selectedGame: GameDetail?


// MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      guard let game = selectedGame else { return }
      print(game.name ?? "not yet")
    }

}
