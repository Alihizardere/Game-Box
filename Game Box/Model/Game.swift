//
//  Game.swift
//  Game Box
//
//  Created by alihizardere on 18.05.2024.
//

struct GameResponse: Decodable {
    let next: String?
    let results: [Game]?
}

// MARK: - Result
struct Game: Decodable {
    let id: Int?
    let name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let shortScreenshots: [ShortScreenshot]?

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case shortScreenshots = "short_screenshots"
    }
}

// MARK: - ShortScreenshot
struct ShortScreenshot: Decodable {
    let id: Int?
    let image: String?
}

