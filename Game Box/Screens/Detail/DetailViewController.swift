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
  var selectedGame: Game?
  var selectedGameDetail: GameDetail?
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
  var viewModel: DetailViewModelProtocol! {
    didSet { viewModel.delegate = self }
  }

// MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    viewModel = DetailViewModel()
  }

  override func viewWillAppear(_ animated: Bool) {
    showInformationView()
  }

  // MARK: - Functions
  private func setupUI(){
    configureSelectedInfo()
    updateView()
    gameImage.layer.cornerRadius = 10
    favoritesButton.layer.cornerRadius = 20
    trailerButton.layer.cornerRadius = 20

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonImageTapped))
    backButtonImage.isUserInteractionEnabled = true
    backButtonImage.addGestureRecognizer(tapGesture)
  }

  private func configureSelectedInfo(){
    guard let game = selectedGameDetail else { return }
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

    if let gameDetail = selectedGameDetail, let game = selectedGame {
      let description = gameDetail.descriptionRaw ?? "No description available"
      infoView.configure(with: description)
      infoView.fetchGameScreenShots(game: game)
    }
  }

  private func showSkillsView() {
    contentView.subviews.forEach { $0.removeFromSuperview() }
    let skillsView = SkillCustomView(frame: contentView.bounds)
    contentView.addSubview(skillsView)

    if let game = selectedGameDetail {
      skillsView.configure(gameDetail: game)
    }
  }

  // MARK: - Actions
  @IBAction func trailerButtonTapped(_ sender: UIButton) {
    guard let gameId = selectedGameDetail?.id else { return }
    viewModel.getTrailer(gameId: gameId)
  }

  @IBAction func favoritesButtonTapped(_ sender: Any) {
    guard let game = selectedGameDetail else { return }
    viewModel.saveToGame(game: game)
  }

  @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
    updateView()
  }
  
  @objc private func backButtonImageTapped() {
    navigationController?.popViewController(animated: true)
  }
}

extension DetailViewController: DetailViewModelDelegate {

  func configureCoreData() -> NSManagedObjectContext? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }
    return appDelegate.persistentContainer.viewContext
  }

  func showSuccessAlert() {
    UIAlertController.showAlert(
      on: self,
      title: "Success",
      message: "Game added to favorites.",
      primaryButtonTitle: "OK"
    )
  }

  func showAlreadyAddedAlert() {
    UIAlertController.showAlert(
      on: self,
      title: "Already Added",
      message: "This game is already in your favorites.",
      primaryButtonTitle: "OK"
    )
  }
  
  func showTrailerAlert() {
    UIAlertController.showAlert(
      on: self,
      title: "Info",
      message: "The trailer for this game has not been uploaded yet.",
      primaryButtonTitle: "OK"
    )
  }

  func playGameTrailer(url: URL) {
    let player = AVPlayer(url: url)
    let playerViewController = AVPlayerViewController()
    playerViewController.player = player

    DispatchQueue.main.async {
      self.present(playerViewController, animated: true) {
        playerViewController.player?.play()
      }
    }
  }
}
