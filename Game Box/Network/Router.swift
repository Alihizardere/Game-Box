//
//  Router.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {

  case allGames

  // MARK: - method
  var method: HTTPMethod {
    switch self {
    case .allGames:
      return .get
    }
  }
  // MARK: - Parameters
  var parameters: [String: Any]? {
    switch self {
    case .allGames:
        return nil
    }
  }
  // MARK: - encoding
  var encoding: ParameterEncoding {
    JSONEncoding.default
  }
  // MARK: - url
  var url: URL {
    switch self {
    case .allGames:
      let url = URL(string: Constants.gameURL)
      return url!
    }
  }

  func asURLRequest() throws -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    return try encoding.encode(urlRequest, with: parameters)
  }
}
