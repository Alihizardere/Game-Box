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
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var gameImage: UIImageView!
  @IBOutlet weak var gameNameLabel: UILabel!
  @IBOutlet weak var gameReleasedDate: UILabel!
  @IBOutlet weak var trailerButton: UIButton!
  @IBOutlet weak var categoryName: UILabel!
  @IBOutlet weak var backButtonImage: UIImageView!
  @IBOutlet weak var segmentedControl: UISegmentedControl!

// MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  // MARK: - Functions
  private func setupUI(){
    configureSelectedInfo()
    updateView()
    gameImage.layer.cornerRadius = 10
    trailerButton.layer.cornerRadius = 20

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonImageTapped))
    backButtonImage.isUserInteractionEnabled = true
    backButtonImage.addGestureRecognizer(tapGesture)
  }

  private func configureSelectedInfo(){
    guard let game = selectedGame else { return }
    print(game.backgroundImage ?? "")
    if let url = URL(string: game.backgroundImage ?? "") {
      backgroundImage.kf.setImage(with: url)
      gameImage.kf.setImage(with: url)
    }
    gameNameLabel.text = game.name
    gameReleasedDate.text = game.released
    categoryName.text = game.genres?.first?.name
  }

  private func updateView() {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      showInformationView()
    case 1:
      showSkillsView()
    default:
      break
    }
  }

  private func showInformationView() {
    contentView.subviews.forEach { $0.removeFromSuperview() }
    let infoView = InformationCustomView(frame: contentView.bounds)
    contentView.addSubview(infoView)

    if let game = selectedGame {
      let description = game.descriptionRaw ?? "No description available"
      infoView.configure(with: description)
    }
  }

  private func showSkillsView() {
    contentView.subviews.forEach { $0.removeFromSuperview() }
    let skillsView = SkillCustomView(frame: contentView.bounds)
    contentView.addSubview(skillsView)

    if let game = selectedGame {
      skillsView.configure(gameDetail: game)
    }
  }

  // MARK: - Actions
  @IBAction func trailerButtonTapped(_ sender: UIButton) {
  }

  @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
    updateView()
  }
  
  @objc private func backButtonImageTapped() {
    navigationController?.popViewController(animated: true)
  }
}
