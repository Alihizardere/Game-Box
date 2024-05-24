//
//  DetailViewController.swift
//  Game Box
//
//  Created by alihizardere on 20.05.2024.
//

import UIKit
import Kingfisher
import CoreData

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
  @IBOutlet weak var favoritesButton: UIButton!
  
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
    favoritesButton.layer.cornerRadius = 23
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

  private func saveToFavorites(_ game: GameDetail) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext

    let favoriteGame = GameEntity(context: context)
    favoriteGame.id = Int64(game.id ?? 0)
    favoriteGame.name = game.name
    favoriteGame.released = game.released
    favoriteGame.backgroundImageURL = game.backgroundImage
    favoriteGame.rating = game.rating ?? 0

    do {
      try context.save()
      print("Game saved")
    } catch {
      print(error.localizedDescription)
    }
  }

  // MARK: - Actions
  @IBAction func trailerButtonTapped(_ sender: UIButton) {
  }

  @IBAction func favoritesButtonTapped(_ sender: Any) {
    guard let game = selectedGame else { return }

    let alert = UIAlertController(title: "Add to favorites", message: "Do you want to add this game to your favorites?", preferredStyle: .alert)
    let addAction = UIAlertAction(title: "Add", style: .default) { _ in
      self.saveToFavorites(game)
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    alert.addAction(addAction)
    alert.addAction(cancelAction)

    present(alert, animated: true, completion: nil)
  }

  @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
    updateView()
  }
  
  @objc private func backButtonImageTapped() {
    navigationController?.popViewController(animated: true)
  }
}
