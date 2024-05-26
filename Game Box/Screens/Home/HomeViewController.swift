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
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var gameCollectionViewTopConstraint: NSLayoutConstraint!
  var gameInfo: Game?

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
    viewModel.startTimer()
    navigationController?.isNavigationBarHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    viewModel.stopTimer()
  }

  // MARK: - Functions
  private func setupUI(){
    // MARK: - Slider CollectionView
    sliderCollectionView.delegate = self
    sliderCollectionView.dataSource = self
    sliderCollectionView.register(cellType: SlideCell.self)
    sliderCollectionView.layer.cornerRadius = 10

    // MARK: - Game CollectionView
    gameCollectionView.delegate = self
    gameCollectionView.dataSource = self
    gameCollectionView.register(cellType: GameCell.self)

    searchBar.delegate = self
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toDetail" {
      let destinationVC = segue.destination as! DetailViewController
      guard let gameDetail = sender as? GameDetail else { return }
      destinationVC.selectedGameDetail = gameDetail
      destinationVC.selectedGame = gameInfo
    }
  }

  private func updateGameCollectionViewTopConstraint(isActive: Bool) {
    if isActive {
      gameCollectionViewTopConstraint.constant = -240
    } else {
      gameCollectionViewTopConstraint.constant = 0
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }
}

// MARK: - CollectionView Delegates
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case sliderCollectionView:
      return viewModel.sliderGames.count
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
      let item = viewModel.sliderGames[indexPath.row]
      if let url = URL(string: item.backgroundImage ?? "") {
        cell.slideImageView.kf.setImage(with: url)
      }
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
      viewModel.fetchDetail(gameId: id)
      gameInfo = game
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView == sliderCollectionView {
      let width = scrollView.frame.width
      let currentPage = Int(scrollView.contentOffset.x / width )
      viewModel.updateCurrentPage(to: currentPage)
    }
  }
}

// MARK: - SearchBar Delegates
extension HomeViewController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    updateGameCollectionViewTopConstraint(isActive: true)
  }

  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    updateGameCollectionViewTopConstraint(isActive: false)
  }
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.filterGames(with: searchText)
  }

  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.resignFirstResponder()
    updateGameCollectionViewTopConstraint(isActive: false)
    viewModel.filterGames(with: "")
  }
}

// MARK: - HomeViewModelDelegates
extension HomeViewController:  HomeViewModelDelegate {
  
  func reloadData() {
    gameCollectionView.reloadData()
    sliderCollectionView.reloadData()
  }

  func navigateToDetail(with gameDetail: GameDetail) {
      performSegue(withIdentifier: "toDetail", sender: gameDetail)
  }

  func updateBackgroundImage(page: Int) {
    if let url = URL(string: viewModel.sliderGames[page].backgroundImage ?? "") {
      backgroundImage.kf.setImage(with: url)
    }
  }

  func updatePageControl(currentPage: Int) {
    pageControl.currentPage = currentPage
    let indexPath = IndexPath(item: currentPage, section: 0)
    sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    updateBackgroundImage(page: currentPage)
  }

  func showEmptyView() {
    let emptyView = EmptyView(
      frame: CGRect(
        x: 0,
        y: view.frame.height / 12,
        width: view.frame.width ,
        height: view.frame.height / 2
      )
    )
    view.addSubview(emptyView)
  }

  func hideEmptyView() {
    for subview in view.subviews {
      if let emptyView = subview as? EmptyView {
        emptyView.removeFromSuperview()
      }
    }
  }
}

