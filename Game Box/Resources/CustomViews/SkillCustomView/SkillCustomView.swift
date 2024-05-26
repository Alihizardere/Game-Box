//
//  SkillCustomView.swift
//  Game Box
//
//  Created by alihizardere on 23.05.2024.
//

import UIKit

class SkillCustomView: UIView {

  // MARK: - Properties
  @IBOutlet weak var publisherCollectionView: UICollectionView!
  @IBOutlet weak var platformCollectionView: UICollectionView!
  @IBOutlet weak var tagCollectionView: UICollectionView!
  var viewModel: DetailViewModelSkillProtocol! {
    didSet { viewModel.delegateSkill = self }
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
    publisherCollectionView.delegate = self
    publisherCollectionView.dataSource = self
    publisherCollectionView.register(cellType: PublisherCell.self)

    platformCollectionView.delegate = self
    platformCollectionView.dataSource = self
    platformCollectionView.register(cellType: PlatformCell.self)

    tagCollectionView.delegate = self
    tagCollectionView.dataSource = self
    tagCollectionView.register(cellType: TagCell.self)
  }

  func configure(gameDetail: GameDetail){
    viewModel.configureCollectionView(game: gameDetail)
  }

  private func commonInit() {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "SkillCustomView", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    view.frame = self.bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
  }

  private func calculateCellSize(for text: String?, in collectionView: UICollectionView) -> CGSize {

    guard let text = text else { return .zero }
    let label = UILabel()
    label.text = text
    label.sizeToFit()
    let cellWidth = label.frame.width + 20
    let cellHeight: CGFloat

    switch collectionView {
    case platformCollectionView:
      cellHeight = collectionView.frame.height / 4
    case publisherCollectionView:
      cellHeight = collectionView.frame.height / 2.3
    case tagCollectionView:
      cellHeight = collectionView.frame.height / 8
    default:
      cellHeight = 50
    }
    return CGSize(width: cellWidth, height: cellHeight)
  }
}

// MARK: - CollectionView Delegates
extension SkillCustomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case platformCollectionView:
      return viewModel.numberOfItems(in:  "platforms")
    case publisherCollectionView:
      return viewModel.numberOfItems(in: "publishers")
    case tagCollectionView:
      return viewModel.numberOfItems(in: "tags")
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case platformCollectionView:
      let cell = collectionView.dequeCell(cellType: PlatformCell.self, indexPath: indexPath)
      let platform = viewModel.item(at: indexPath, in: "platforms")
      cell.platformTitle.text = platform
      return cell
    case publisherCollectionView:
      let cell = collectionView.dequeCell(cellType: PublisherCell.self, indexPath: indexPath)
      let publisher = viewModel.item(at: indexPath, in: "publishers")
      cell.publisherName.text = publisher
      return cell
    case tagCollectionView:
      let cell = collectionView.dequeCell(cellType: TagCell.self, indexPath: indexPath)
      let tag = viewModel.item(at: indexPath, in: "tags")
      cell.tagTitle.text = tag
      return cell
    default:
      return UICollectionViewCell()
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let section: String

    switch collectionView {
    case platformCollectionView:
      section = "platforms"
    case publisherCollectionView:
      section = "publishers"
    case tagCollectionView:
      section = "tags"
    default:
      return .zero
    }
    let item = viewModel.item(at: indexPath, in: section)
    return calculateCellSize(for: item, in: collectionView)
  }
}

// MARK: - DetailViewModelSkillDelegate
extension SkillCustomView: DetailViewModelSkillDelegate {
  func reloadData() {
    publisherCollectionView.reloadData()
    platformCollectionView.reloadData()
    tagCollectionView.reloadData()
  }
}
