//
//  EmptyView.swift
//  Game Box
//
//  Created by alihizardere on 25.05.2024.
//

import UIKit

class EmptyView: UIView {

  // MARK: - Properties
  var imageView: UIImageView!
  var messageLabel: UILabel!

  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupView()
  }

  // MARK: - Functions
  private func setupView() {
    backgroundColor = .clear 
    imageView = UIImageView(image: UIImage(named: "no-results"))
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)

    messageLabel = UILabel()
    messageLabel.text = "No results found"
    messageLabel.textColor = .gray
    messageLabel.font = .boldSystemFont(ofSize: 25)
    messageLabel.textAlignment = .center
    addSubview(messageLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      imageView.topAnchor.constraint(equalTo: topAnchor, constant: 120),
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.widthAnchor.constraint(equalToConstant: 250),
      imageView.heightAnchor.constraint(equalToConstant: 250),

      messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
    ])
  }
}

