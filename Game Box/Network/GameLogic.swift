//
//  GameLogic.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

import Foundation

protocol GameLogicProtocol {
  func getAllGames(completionHandler: @escaping (Result<GameResponse, Error>) -> Void)
}

final class GameLogic: GameLogicProtocol {

  static let shared: GameLogic = {
    let instance = GameLogic()
    return instance
  }()

  private init() {}

  func getAllGames(completionHandler: @escaping (Result<GameResponse, any Error>) -> Void) {
    Webservice.shared.request(
      request: Router.allGames,
      decodeType: GameResponse.self,
      completionHandler: completionHandler
    )
  }
}
