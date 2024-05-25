//
//  FavoritesViewModel.swift
//  Game Box
//
//  Created by alihizardere on 25.05.2024.
//

import Foundation
import CoreData


protocol FavoriteViewModelDelegate: AnyObject {
  func reloadData()
  func configureCoreData() -> NSManagedObjectContext?
  func showEmptyView()
  func hideEmptyView()
}

protocol FavoriteViewModelProtocol {
  var delegate: FavoriteViewModelDelegate? { get set }
  var numberOfItems: Int { get }
  func game(index: IndexPath) -> GameEntity?
  func load()
  func delete(index: IndexPath)
}

final class FavoritesViewModel {

  // MARK: - Properties
  var favoriteGames = [GameEntity]()
  weak var delegate: FavoriteViewModelDelegate?

  // MARK: - CRUD Operations
  fileprivate func fetchFavoriteGames() {
    guard let context = self.delegate?.configureCoreData() else {
      return
    }
    let fetchRequest = GameEntity.fetchRequest()

    do {
      favoriteGames = try context.fetch(fetchRequest)
      self.delegate?.reloadData()
      favoriteGames.isEmpty ? self.delegate?.showEmptyView() : self.delegate?.hideEmptyView()
    } catch {
      print(error.localizedDescription)
    }
  }

  fileprivate func deleteGame(at indexPath: IndexPath) {
    guard let context = self.delegate?.configureCoreData() else {
      return
    }
    context.delete(favoriteGames[indexPath.row])
    favoriteGames.remove(at: indexPath.row)
    favoriteGames.isEmpty ? self.delegate?.showEmptyView() : self.delegate?.hideEmptyView()
    do {
      try context.save()
      self.delegate?.reloadData()
    } catch {
      print(error.localizedDescription)
    }
  }
}

// MARK: - FavoriteViewModelProtocols
extension FavoritesViewModel: FavoriteViewModelProtocol {

  func load() {
    fetchFavoriteGames()
  }

  var numberOfItems: Int {
    favoriteGames.count
  }

  func game(index: IndexPath) -> GameEntity? {
    favoriteGames[index.row]
  }

  func delete(index: IndexPath) {
    deleteGame(at: index)
  }
}
