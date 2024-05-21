//
//  HomeViewModel.swift
//  Game Box
//
//  Created by alihizardere on 21.05.2024.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
  func reloadData()
  func navigateToDetail(with gameDetail: GameDetail)
  func updatePageControl(currentPage: Int)
}

protocol HomeViewModelProtocol {
  var delegate: HomeViewModelDelegate? { get set }
  var numberOfItems: Int { get }
  func load()
  func game(index: IndexPath) -> Game?
  func fetchDetail(gameId: Int)
  func filterGames(with searchText: String)
  func startTimer()
  func stopTimer()
  func autoScroll()
  func updateCurrentPage(to page: Int)
}

final class HomeViewModel {

  // MARK: - Properties
  var gameList = [Game]()
  var filteredGameList = [Game]()
  weak var delegate: HomeViewModelDelegate?
  var isFiltering: Bool = false
  private var timer: Timer?
  private var currentPage = 0

  // MARK: - Fetch Operations
  fileprivate func fetchGames() {
    GameLogic.shared.getAllGames { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let gameResponse):
        if let games = gameResponse.results {
          gameList = games
        }
        DispatchQueue.main.async {
          self.delegate?.reloadData()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  func fetchDetail(gameId: Int) {
    GameLogic.shared.getDetailGame(gameId: gameId) { [weak self]  result in
      switch result {
      case .success(let gameDetail):
        self?.delegate?.navigateToDetail(with: gameDetail)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
  func updateCurrentPage(to page: Int) {
    currentPage = page
    delegate?.updatePageControl(currentPage: currentPage)
  }


  var numberOfItems: Int {
    return isFiltering ? filteredGameList.count : gameList.count
  }

  func load() {
    fetchGames()
  }

  func game(index: IndexPath) -> Game? {
    return isFiltering ? filteredGameList[index.row] : gameList[index.row]
  }

  func filterGames(with searchText: String) {
    if searchText.count < 3 {
      isFiltering = false
      filteredGameList = []
    } else {
      isFiltering = true
      filteredGameList = gameList.filter {
        guard let name = $0.name else { return false }
        return name.lowercased().contains(searchText.lowercased())
      }
    }
    self.delegate?.reloadData()
  }

  func startTimer() {
    timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
  }

  func stopTimer() {
    timer?.invalidate()
    timer = nil
  }

  @objc func autoScroll() {
    currentPage = currentPage < Constants.slides.count - 1 ? currentPage + 1 : 0
    delegate?.updatePageControl(currentPage: currentPage)
  }
}
