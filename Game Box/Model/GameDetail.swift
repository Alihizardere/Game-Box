//
//  GameDetail.swift
//  Game Box
//
//  Created by alihizardere on 20.05.2024.
//

import Foundation

// MARK: - GameDetail
struct GameDetail: Decodable {
    let id: Int?
    let name, description: String?
    let released: String?
    let backgroundImage: String?
    let rating: Double?
    let publishers: [Developer]?
    let tags: [Tag]?
    let platforms: [PlatformInfo]?
    let genres: [Genre]?
    let descriptionRaw: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case description
        case released
        case backgroundImage = "background_image"
        case rating
        case platforms, publishers, tags
        case genres
        case descriptionRaw = "description_raw"
    }
}

// MARK: - Genre
struct Genre: Decodable {
  let id: Int?
  let name: String?
  let imageBackground: String?

  enum CodingKeys: String, CodingKey {
    case id, name
    case imageBackground = "image_background"
  }
}

// MARK: - PlatformElement
struct PlatformInfo: Decodable {
    let platform: PlatformDetail?
}

// MARK: - PlatformPlatform
struct PlatformDetail: Decodable {
    let name: String?
}

// MARK: - Developer
struct Developer: Decodable {
    let name: String?
}

// MARK: - Tag
struct Tag: Decodable {
  let name: String?
}





