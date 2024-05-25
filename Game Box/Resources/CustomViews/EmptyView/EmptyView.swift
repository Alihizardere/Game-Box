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
    imageView = UIImageView(image: UIImage(named: "slide1"))
    imageView.contentMode = .scaleAspectFit
    addSubview(imageView)

    messageLabel = UILabel()
    messageLabel.text = "No results"
    messageLabel.textColor = .gray
    messageLabel.font = .boldSystemFont(ofSize: 25)
    messageLabel.textAlignment = .center
    addSubview(messageLabel)

    imageView.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -20),
      imageView.widthAnchor.constraint(equalToConstant: 300),
      imageView.heightAnchor.constraint(equalToConstant: 300),

      messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
      messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
    ])
  }
}

