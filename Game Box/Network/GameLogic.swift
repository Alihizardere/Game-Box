//
//  GameLogic.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

import Foundation

protocol GameLogicProtocol {
  func getAllGames(completionHandler: @escaping (Result<GameResponse, Error>) -> Void)
  func getDetailGame(gameId: Int ,completionHandler: @escaping (Result<GameDetail, Error>) -> Void)
  func getGameTrailer(gameId: Int ,completionHandler: @escaping (Result<GameTrailerResponse, Error>) -> Void)
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

  func getDetailGame(gameId: Int, completionHandler: @escaping (Result<GameDetail, any Error>) -> Void) {
    Webservice.shared.request(
      request: Router.gameDetail(id: gameId),
      decodeType: GameDetail.self,
      completionHandler: completionHandler
    )
  }

  func getGameTrailer(gameId: Int, completionHandler: @escaping (Result<GameTrailerResponse, any Error>) -> Void) {
    Webservice.shared.request(
      request: Router.gameTrailer(id: gameId),
      decodeType: GameTrailerResponse.self,
      completionHandler: completionHandler
    )
  }
}
