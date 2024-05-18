//
//  Game.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

import Foundation

struct GameResponse: Decodable {
    let count: Int?
    let next: String?
    let results: [GameCategory]?
}

struct GameCategory: Decodable {
    let id: Int?
    let name, slug: String?
    let gamesCount: Int?
    let imageBackground: String?
    let games: [Game]?

    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case gamesCount = "games_count"
        case imageBackground = "image_background"
        case games
    }
}

struct Game: Decodable {
    let id: Int?
    let slug, name: String?
    let added: Int?
}

