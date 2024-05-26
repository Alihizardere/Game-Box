//
//  InformationCustomView.swift
//  Game Box
//
//  Created by alihizardere on 23.05.2024.
//

import UIKit

class InformationCustomView: UIView {
  // MARK: - Properties
  @IBOutlet weak var screenShotCollectionView: UICollectionView!
  @IBOutlet weak var descriptionTextView: UITextView!
  var viewModel: DetailViewModelInfoProtocol! {
    didSet { viewModel.delegateInfo = self }
  }

  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    setupUI()
    viewModel = DetailViewModel()
  }

   required init?(coder: NSCoder) {
     super.init(coder: coder)
   }
  
  // MARK: - Functions
  private func setupUI() {
    screenShotCollectionView.delegate = self
    screenShotCollectionView.dataSource = self
    screenShotCollectionView.register(cellType: ScreenShotCell.self)
    screenShotCollectionView.collectionViewLayout = createLayout()
  }

  func configure(with description: String) {
    let englishDescription = parseEnglishDescription(from: description)
    descriptionTextView.text = englishDescription
  }
  
  func fetchGameScreenShots(game: Game){
    viewModel.fetchGameScreenShots(game: game)
  }

  private func commonInit() {
     let bundle = Bundle(for: type(of: self))
     let nib = UINib(nibName: "InformationCustomView", bundle: bundle)
     let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
     view.frame = self.bounds
     view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     addSubview(view)
   }

  private func parseEnglishDescription(from description: String) -> String {
    if let range = description.range(of: "\n\nEspañol") {
      return String(description[..<range.lowerBound])
    } else {
      return description
    }
  }

  private func createLayout() -> UICollectionViewLayout {
      let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6),
                                                 heightDimension: .fractionalHeight(1))
      let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)

      let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                 heightDimension: .fractionalHeight(0.5))
      let smallItem = NSCollectionLayoutItem(layoutSize: smallItemSize)

      let smallItemsGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.4),
                                                       heightDimension: .fractionalHeight(1))
      let smallItemsGroup = NSCollectionLayoutGroup.vertical(layoutSize: smallItemsGroupSize, subitems: [smallItem])

      let mainGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1))
      let mainGroup = NSCollectionLayoutGroup.horizontal(layoutSize: mainGroupSize, subitems: [largeItem, smallItemsGroup])

      let section = NSCollectionLayoutSection(group: mainGroup)
      section.orthogonalScrollingBehavior = .continuous

      return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - CollectionView Delegates
extension InformationCustomView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.numberOfItems
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeCell(cellType: ScreenShotCell.self, indexPath: indexPath)
    let screenShot = viewModel.screenShot(indexPath: indexPath)
    cell.configure(screenShot: screenShot)
    return cell
  }
}

// MARK: - DetailViewModelInfoDelegates
extension InformationCustomView: DetailViewModelInfoDelegate {
  func reloadData() {
    screenShotCollectionView.reloadData()
  }
}
