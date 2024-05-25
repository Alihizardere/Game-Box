//
//  DetailViewController.swift
//  Game Box
//
//  Created by alihizardere on 20.05.2024.
//

import UIKit
import Kingfisher
import CoreData
import AVKit

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
  @IBOutlet weak var ageImage: UIImageView!
  @IBOutlet weak var ageLabel: UILabel!
  
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
    let fetchRequest = GameEntity.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "id == %d", game.id ?? 0)

    do {
      let results = try context.fetch(fetchRequest)
      if results.isEmpty {
        let favoriteGame = GameEntity(context: context)
        favoriteGame.id = Int64(game.id ?? 0)
        favoriteGame.name = game.name
        favoriteGame.released = game.released
        favoriteGame.backgroundImageURL = game.backgroundImage
        favoriteGame.rating = game.rating ?? 0

        try context.save()
        print("Game saved")
        UIAlertController.showAlert(on: self, title: "Success", message: "Game added to favorites.", primaryButtonTitle: "OK")
      } else {
        UIAlertController.showAlert(on: self, title: "Already Added", message: "This game is already in your favorites.", primaryButtonTitle: "OK")
      }

    } catch {
      print(error.localizedDescription)
    }
  }

  // MARK: - Actions
  @IBAction func trailerButtonTapped(_ sender: UIButton) {
    guard let gameId = selectedGame?.id else { return }
    print(gameId)
    GameLogic.shared.getGameTrailer(gameId: gameId) { result in
      switch result {
      case .success(let trailerResponse):
        if let urlString = trailerResponse.results?.first?.data?.max, let url = URL(string: urlString) {
          self.playTrailer(url: url)
        } else {
          UIAlertController.showAlert(
            on: self,
            title: "Info",
            message: "The trailer for this game has not been uploaded yet.",
            primaryButtonTitle: "OK"
          )
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func playTrailer(url: URL) {
    let player = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player

    DispatchQueue.main.async {
      self.present(playerViewController, animated: true) {
        playerViewController.player?.play()
      }
    }
  }

  @IBAction func favoritesButtonTapped(_ sender: Any) {
    guard let game = selectedGame else { return }
    self.saveToFavorites(game)
  }

  @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
    updateView()
  }
  
  @objc private func backButtonImageTapped() {
    navigationController?.popViewController(animated: true)
  }
}
