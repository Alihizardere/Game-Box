//
//  SceneDelegate.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

    guard let windowScene = (scene as? UIWindowScene) else { return }
    self.window = UIWindow(windowScene: windowScene)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    guard let rootVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController  else { return }
    let viewModel = HomeViewModel()
    rootVC.viewModel = viewModel
    self.window?.makeKeyAndVisible()
    self.window?.rootViewController = rootVC
  }

  func sceneDidDisconnect(_ scene: UIScene) {

  }

  func sceneDidBecomeActive(_ scene: UIScene) {

  }

  func sceneWillResignActive(_ scene: UIScene) {

  }

  func sceneWillEnterForeground(_ scene: UIScene) {

  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }


}

