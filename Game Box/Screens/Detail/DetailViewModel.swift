//
//  DetailViewModel.swift
//  Game Box
//
//  Created by alihizardere on 25.05.2024.
//

import Foundation
import CoreData

protocol DetailViewModelDelegate: AnyObject{
  func configureCoreData() -> NSManagedObjectContext?
  func showSuccessAlert()
  func showAlreadyAddedAlert()
  func showTrailerAlert()
  func playGameTrailer(url: URL)
}

protocol DetailViewModelProtocol {
  var delegate: DetailViewModelDelegate? { get set }
  func saveToGame(game: GameDetail)
  func getTrailer(gameId: Int)
}

protocol DetailViewModelSkillDelegate: AnyObject {
  func reloadData()
}

protocol DetailViewModelSkillProtocol {
  var delegateSkill: DetailViewModelSkillDelegate? { get set }
  func numberOfItems(in section: String) -> Int
  func item(at indexPath: IndexPath, in section: String) -> String?
  func configureCollectionView(game: GameDetail)
}

protocol DetailViewModelInfoDelegate: AnyObject {
  func reloadData()
}

protocol DetailViewModelInfoProtocol {
  var delegateInfo: DetailViewModelInfoDelegate? { get set}
  var numberOfItems: Int { get }
  func screenShot(indexPath: IndexPath) -> String
  func fetchGameScreenShots(game: Game)
}

final class DetailViewModel {
  
  // MARK: - Properties
  weak var delegate: DetailViewModelDelegate?
  weak var delegateSkill: DetailViewModelSkillDelegate?
  weak var delegateInfo: DetailViewModelInfoDelegate?
  var publishers = [String]()
  var platforms = [String]()
  var tags = [String]()
  var screenShots = [String]()

  static let sectionPublishers = "publishers"
  static let sectionPlatforms = "platforms"
  static let sectionTags = "tags"

  fileprivate func saveToFavorites(_ game: GameDetail) {

    guard let context = delegate?.configureCoreData() else { return }
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
        delegate?.showSuccessAlert()

      } else {
        delegate?.showAlreadyAddedAlert()
      }
    } catch {
      print(error.localizedDescription)
    }
  }

  private func getGameTrailer(gameId: Int) {
    GameLogic.shared.getGameTrailer(gameId: gameId) { result in
      switch result {
      case .success(let trailerResponse):
        if let urlString = trailerResponse.results?.first?.data?.max, let url = URL(string: urlString) {
          self.delegate?.playGameTrailer(url: url)
        } else {
          self.delegate?.showTrailerAlert()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

// MARK: - DetailViewModelProtocols
extension DetailViewModel: DetailViewModelProtocol {

func saveToGame(game: GameDetail) {
    saveToFavorites(game)
  }

  func getTrailer(gameId: Int){
    getGameTrailer(gameId: gameId)
  }
}

// MARK: - DetailViewModelSkillProtocols
extension DetailViewModel: DetailViewModelSkillProtocol {

  func numberOfItems(in section: String) -> Int {
    switch section {
    case DetailViewModel.sectionPublishers:
      return publishers.count
    case DetailViewModel.sectionPlatforms:
      return platforms.count
    case DetailViewModel.sectionTags:
      return tags.count
    default:
      return 0
    }
  }

  func item(at indexPath: IndexPath, in section: String) -> String? {
    switch section {
    case DetailViewModel.sectionPublishers:
      guard indexPath.row < publishers.count else { return nil }
      return publishers[indexPath.row]
    case DetailViewModel.sectionPlatforms:
      guard indexPath.row < platforms.count else { return nil }
      return platforms[indexPath.row]
    case DetailViewModel.sectionTags:
      guard indexPath.row < tags.count else { return nil }
      return tags[indexPath.row]
    default:
      return nil
    }
  }

  func configureCollectionView(game gameDetail: GameDetail) {
    platforms = gameDetail.platforms?.compactMap { $0.platform?.name } ?? []
    publishers = gameDetail.publishers?.compactMap {$0.name } ?? []
    tags = gameDetail.tags?.compactMap { $0.name } ?? []
    delegateSkill?.reloadData()
  }
}

// MARK: - DetailViewModelInfoProtocols
extension DetailViewModel: DetailViewModelInfoProtocol {

  var numberOfItems: Int {
    screenShots.count
  }
  func screenShot(indexPath: IndexPath) -> String {
    screenShots[indexPath.row]
  }

  func fetchGameScreenShots(game: Game){
    screenShots = game.shortScreenshots?.compactMap { $0.image } ?? []
    delegateInfo?.reloadData()
  }
}
