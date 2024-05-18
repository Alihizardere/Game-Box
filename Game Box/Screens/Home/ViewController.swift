//
//  ViewController.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

import UIKit

class ViewController: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var sliderCollectionView: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  var slides = [UIImage(named: "slide1"), UIImage(named: "slide2"), UIImage(named: "slide3")]
  var currentPage = 0 {
    didSet{ pageControl.currentPage = currentPage }
  }
  var timer: Timer?

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
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
  }

  private func configurationCollectionView(){

    // MARK: - Slider CollectionView
    sliderCollectionView.delegate = self
    sliderCollectionView.dataSource = self
    sliderCollectionView.register(UINib(nibName: SlideCell.identifier, bundle: nil), forCellWithReuseIdentifier: SlideCell.identifier)
  }

  private func configureTimer() {
    timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
  }

  // MARK: - Selectors
  @objc private func autoScroll() {
    currentPage = currentPage < slides.count - 1 ? currentPage + 1 : 0
    let indexPath = IndexPath(item: currentPage, section: 0)
    sliderCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}

// MARK: - CollectionView Delegates

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    slides.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlideCell.identifier, for: indexPath) as! SlideCell
    let item = slides[indexPath.row]
    cell.slideImageView.image = item
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = scrollView.frame.width
    currentPage = Int(scrollView.contentOffset.x / width )
  }
}
