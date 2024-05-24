//
//  InformationCustomView.swift
//  Game Box
//
//  Created by alihizardere on 23.05.2024.
//

import UIKit

class InformationCustomView: UIView {

  @IBOutlet weak var screenShotCollectionView: UICollectionView!
  @IBOutlet weak var descriptionTextView: UITextView!
  
  override init(frame: CGRect) {
     super.init(frame: frame)
     commonInit()
    screenShotCollectionView.delegate = self
    screenShotCollectionView.dataSource = self
    screenShotCollectionView.register(cellType: ScreenShotCell.self)
   }

   required init?(coder: NSCoder) {
     super.init(coder: coder)
   }

  func configure(with descripton: String) {
    descriptionTextView.text = descripton
  }
  
  private func commonInit() {
     let bundle = Bundle(for: type(of: self))
     let nib = UINib(nibName: "InformationCustomView", bundle: bundle)
     let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
     view.frame = self.bounds
     view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     addSubview(view)
   }
}

// MARK: - CollectionView Delegates
extension InformationCustomView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    3
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeCell(cellType: ScreenShotCell.self, indexPath: indexPath)
    cell.cardView.backgroundColor = .systemGreen
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    .init(width: collectionView.frame.height , height: collectionView.frame.height )
  }
}
