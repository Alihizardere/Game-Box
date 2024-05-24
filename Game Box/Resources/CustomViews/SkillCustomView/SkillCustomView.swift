//
//  SkillCustomView.swift
//  Game Box
//
//  Created by alihizardere on 23.05.2024.
//

import UIKit

class SkillCustomView: UIView {

  @IBOutlet weak var publisherCollectionView: UICollectionView!
  @IBOutlet weak var platformCollectionView: UICollectionView!
  @IBOutlet weak var tagCollectionView: UICollectionView!

  var publishers = [String]()
  var platforms = [String]()
  var tags = [String]()

  override init(frame: CGRect) {
    super.init(frame: frame)
    commonInit()
    setupUI()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func setupUI() {
    platformCollectionView.delegate = self
    platformCollectionView.dataSource = self
    platformCollectionView.register(cellType: PlatformCell.self)

    publisherCollectionView.delegate = self
    publisherCollectionView.dataSource = self
    publisherCollectionView.register(cellType: PublisherCell.self)

    tagCollectionView.delegate = self
    tagCollectionView.dataSource = self
    tagCollectionView.register(cellType: TagCell.self)

    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = 5
    layout.minimumInteritemSpacing = 5
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    platformCollectionView.collectionViewLayout = layout
  }

  func configure(gameDetail: GameDetail){
    platforms = gameDetail.platforms?.compactMap { $0.platform?.name } ?? []
    platformCollectionView.reloadData()

    publishers = gameDetail.publishers?.compactMap {$0.name } ?? []
    publisherCollectionView.reloadData()

    tags = gameDetail.tags?.compactMap { $0.name } ?? []
    tagCollectionView.reloadData()
  }

  private func commonInit() {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "SkillCustomView", bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
    view.frame = self.bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(view)
  }
}

// MARK: - CollectionView Delegates
extension SkillCustomView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch collectionView {
    case platformCollectionView:
      return platforms.count
    case publisherCollectionView:
      return publishers.count
    case tagCollectionView:
      return tags.count
    default:
      return 0
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch collectionView {
    case platformCollectionView:
      let cell = collectionView.dequeCell(cellType: PlatformCell.self, indexPath: indexPath)
      let platform = platforms[indexPath.item]
      cell.backgroundColor = .black
      cell.platformTitle.text = platform
      return cell
    case publisherCollectionView:
      let cell = collectionView.dequeCell(cellType: PublisherCell.self, indexPath: indexPath)
      let publisher = publishers[indexPath.item]
      cell.backgroundColor = .black
      cell.publisherName.text = publisher
      return cell
    case tagCollectionView:
      let cell = collectionView.dequeCell(cellType: TagCell.self, indexPath: indexPath)
      let tag = tags[indexPath.item]
      cell.backgroundColor = .black
      cell.tagTitle.text = tag
      return cell
    default:
      return UICollectionViewCell()
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch collectionView {
    case platformCollectionView:
      let platform = platforms[indexPath.item]
      let label = UILabel()
      label.text = platform
      label.sizeToFit()
      let cellWidth = label.frame.width + 20
      let cellHeight = collectionView.frame.height / 4
      return CGSize(width: cellWidth, height: cellHeight)
    case publisherCollectionView:
      let publisher = publishers[indexPath.item]
      let label = UILabel()
      label.text = publisher
      label.sizeToFit()
      let cellWidth = label.frame.width + 20
      let cellHeight = collectionView.frame.height / 2.3
      return CGSize(width: cellWidth, height: cellHeight)
    case tagCollectionView:
      let tag = tags[indexPath.item]
      let label = UILabel()
      label.text = tag
      label.sizeToFit()
      let cellWidth = label.frame.width + 20
      let cellHeight = collectionView.frame.height / 8
      return CGSize(width: cellWidth, height: cellHeight)
    default:
      return CGSize(width: 50, height: 50)
    }
  }
}

