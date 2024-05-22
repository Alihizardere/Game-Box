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
  var viewModel: HomeViewModelProtocol! {
    didSet { viewModel.delegate = self }
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    viewModel.load()
    navigationController?.isNavigationBarHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.stopTimer()
  }

  // MARK: - Functions
  private func setupUI(){
    configurationCollectionView()
    viewModel.startTimer()
    searchBar.delegate = self

  }


  private func fetchDetail(gameId: Int) {
    viewModel.fetchDetail(gameId: gameId)
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
    sliderCollectionView.register(cellType: SlideCell.self)

    // MARK: - Game CollectionView
    gameCollectionView.delegate = self
    gameCollectionView.dataSource = self
    gameCollectionView.register(cellType: GameCell.self)
  }
}

// MARK: - CollectionView Delegates
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case sliderCollectionView:
      return Constants.slides.count
    case gameCollectionView:
      return viewModel.numberOfItems
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {

    case sliderCollectionView:
      let cell = collectionView.dequeCell(cellType: SlideCell.self, indexPath: indexPath)
      let item = Constants.slides[indexPath.row]
      cell.slideImageView.image = item
      return cell
    case gameCollectionView:
      let cell = collectionView.dequeCell(cellType: GameCell.self, indexPath: indexPath)
      if let game = viewModel.game(index: indexPath) {
        cell.setup(game: game)
      }
      return cell
    default:
      fatalError("Unexpected collection view")
    }
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView ==  gameCollectionView {
      guard let game = viewModel.game(index: indexPath),
            let id = game.id else { return }
      fetchDetail(gameId: id)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = scrollView.frame.width
    let currentPage = Int(scrollView.contentOffset.x / width )
    viewModel.updateCurrentPage(to: currentPage)
  }
}

// MARK: - SearchBar Delegates
extension HomeViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.filterGames(with: searchText)
  }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController:  HomeViewModelDelegate {
  func reloadData() {
    gameCollectionView.reloadData()
  }

  func navigateToDetail(with gameDetail: GameDetail) {
      performSegue(withIdentifier: "toDetail", sender: gameDetail)
  }

  func updatePageControl(currentPage: Int) {
    pageControl.currentPage = currentPage
    let indexPath = IndexPath(item: currentPage, section: 0)
    sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}

