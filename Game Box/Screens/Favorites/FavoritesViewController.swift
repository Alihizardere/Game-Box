//
//  FavoritesViewController.swift
//  Game Box
//
//  Created by alihizardere on 24.05.2024.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var favoriteTableView: UITableView!
  var viewModel: FavoriteViewModelProtocol! {
    didSet { viewModel.delegate = self }
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = false
    viewModel = FavoritesViewModel()
    favoriteTableView.delegate = self
    favoriteTableView.dataSource = self
    favoriteTableView.register(UINib(nibName: FavoriteCell.identifier, bundle: nil), forCellReuseIdentifier: FavoriteCell.identifier)
  }

  override func viewWillAppear(_ animated: Bool) {
    viewModel.load()
  }
}

// MARK: - TableView Delegates
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numberOfItems
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier) as! FavoriteCell
    if let game = viewModel.game(index: indexPath) {
      cell.configure(game: game)
    }
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.height / 6
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in

      let game = self.viewModel.game(index: indexPath)
      UIAlertController.showAlert(
        on: self ,
        title: "Delete Game",
        message: "Are you sure you want to delete this game?",
        primaryButtonTitle: "OK",
        primaryButtonStyle: .destructive,
        primaryButtonHandler: {
          self.viewModel.delete(index: indexPath)
        },
        secondaryButtonTitle: "Cancel")
    }
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}

// MARK: - FavoriteViewModelDelegate
extension FavoritesViewController: FavoriteViewModelDelegate {
  
  func reloadData() {
    favoriteTableView.reloadData()
  }

  func configureCoreData() -> NSManagedObjectContext? {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      return nil
    }
    return appDelegate.persistentContainer.viewContext
  }

  func showEmptyView() {
    let emptyView = EmptyView(frame: CGRect(x: 0, y: 200, width: view.frame.width , height: view.frame.height / 2))
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
