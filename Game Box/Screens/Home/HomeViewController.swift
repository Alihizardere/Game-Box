//
//  ViewController.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

import UIKit

class HomeViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var gameCollectionView: UICollectionView!
  @IBOutlet weak var sliderCollectionView: UICollectionView!
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var pageControl: UIPageControl!
  lazy var gameList = [Game]()
  lazy var filteredGameList = [Game]()
  var isFiltering: Bool = false
  var isSliderHidden: Bool = false
  var currentPage = 0 {
    didSet{ pageControl.currentPage = currentPage }
  }
  var timer: Timer?

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupUI()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    timer?.invalidate()
  }

  // MARK: - Functions
  private func setupUI(){
    configurationCollectionView()
    configureTimer()
    fetchGames()
    searchBar.delegate = self
  }

  private func fetchGames(){
    GameLogic.shared.getAllGames { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let gameResponse):
        if let games = gameResponse.results {
          gameList = games
        }
        DispatchQueue.main.async {
          self.gameCollectionView.reloadData()
        }
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  private func fetchDetail(gameId: Int) {
    GameLogic.shared.getDetailGame(gameId: gameId) {  result in
      switch result {
      case .success(let gameDetail):
        self.performSegue(withIdentifier: "toDetail", sender: gameDetail)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toDetail" {
      let destinationVC = segue.destination as! DetailViewController
      guard let game = sender as? GameDetail else { return }
      destinationVC.selectedGame = game
    }
  }

  private func configurationCollectionView(){

    // MARK: - Slider CollectionView
    sliderCollectionView.delegate = self
    sliderCollectionView.dataSource = self
    sliderCollectionView.register(UINib(nibName: SlideCell.identifier, bundle: nil), forCellWithReuseIdentifier: SlideCell.identifier)

    // MARK: - Game CollectionView
    gameCollectionView.delegate = self
    gameCollectionView.dataSource = self
    gameCollectionView.register(UINib(nibName: GameCell.identifier, bundle: nil), forCellWithReuseIdentifier: GameCell.identifier)
  }

  private func configureTimer() {
    timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
  }

  // MARK: - Selectors
  @objc private func autoScroll() {
    currentPage = currentPage < Constants.slides.count - 1 ? currentPage + 1 : 0
    let indexPath = IndexPath(item: currentPage, section: 0)
    sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}

// MARK: - CollectionView Delegates
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case sliderCollectionView:
      return Constants.slides.count
    case gameCollectionView:
      return isFiltering ? filteredGameList.count : gameList.count
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {

    case sliderCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideCell.identifier, for: indexPath) as! SlideCell
      let item = Constants.slides[indexPath.row]
      cell.slideImageView.image = item
      return cell
    case gameCollectionView:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCell.identifier, for: indexPath) as! GameCell
      let game = isFiltering ? filteredGameList[indexPath.row] : gameList[indexPath.row]
      cell.setup(game: game)
      return cell
    default:
      fatalError("Unexpected collection view")
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView ==  gameCollectionView {
      let game = gameList[indexPath.row]
      guard let id = game.id else { return }
      fetchDetail(gameId: id)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = scrollView.frame.width
    currentPage = Int(scrollView.contentOffset.x / width )
  }
}

// MARK: - SearchBar Delegates
extension HomeViewController: UISearchBarDelegate {

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText.count < 3 {
      isFiltering = false
      filteredGameList = []
      pageControl.isHidden = false
      sliderCollectionView.isHidden = false
      gameCollectionView.reloadData()
    } else {
      isFiltering = true
      filteredGameList = gameList.filter {
        pageControl.isHidden = true
        sliderCollectionView.isHidden = true
        guard let name = $0.name else { return false }
        return name.lowercased().contains(searchText.lowercased())
      }
      gameCollectionView.reloadData()
    }
  }
}
