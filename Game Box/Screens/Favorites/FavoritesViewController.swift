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
  var favoriteGames = [GameEntity]()

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isHidden = false

    favoriteTableView.delegate = self
    favoriteTableView.dataSource = self
    favoriteTableView.register(UINib(nibName: FavoriteCell.identifier, bundle: nil), forCellReuseIdentifier: FavoriteCell.identifier)
  }

  override func viewWillAppear(_ animated: Bool) {
    fetchFavoriteGames()
  }

  //  MARK: - Functions
  private func fetchFavoriteGames() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest = GameEntity.fetchRequest()

    do {
      favoriteGames = try context.fetch(fetchRequest)
      favoriteTableView.reloadData()
    } catch {
      print(error.localizedDescription)
    }
  }

  private func deleteGame(_ game: GameEntity) {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    let context = appDelegate.persistentContainer.viewContext
    context.delete(game)

    do {
      try context.save()
    } catch {
      print(error.localizedDescription)
    }
  }
}

// MARK: - TableView Delegates
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    favoriteGames.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteCell.identifier) as! FavoriteCell
    let game = favoriteGames[indexPath.row]
    cell.configure(game: game)
    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return tableView.frame.height / 6
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in

      let game = self.favoriteGames[indexPath.row]
      let alertController = UIAlertController(title: "Delete Game", message: "Are you sure you want to delete this game?", preferredStyle: .alert)

      let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      let OkButton = UIAlertAction(title: "Delete", style: .destructive) { _ in
        self.deleteGame(game)
        self.favoriteGames.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      }

      alertController.addAction(cancelButton)
      alertController.addAction(OkButton)
      self.present(alertController, animated: true, completion: nil)
    }
    return UISwipeActionsConfiguration(actions: [deleteAction])
  }
}

