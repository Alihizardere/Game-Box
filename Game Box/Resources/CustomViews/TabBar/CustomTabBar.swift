//
//  CustomTabBar.swift
//  Game Box
//
//  Created by alihizardere on 22.05.2024.
//

import UIKit

class CustomTabBar: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()
    setupBlurEffect()
  }

  private func setupBlurEffect() {
    let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = tabBar.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tabBar.insertSubview(blurEffectView, at: 0)
  }
}
