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
    let slug, name, nameOriginal, description: String?
    let metacritic: Int?
    let metacriticPlatforms: [MetacriticPlatform]?
    let released: String?
    let tba: Bool?
    let updated: String?
    let backgroundImage, backgroundImageAdditional: String?
    let website: String?
    let rating: Double?
    let ratingTop: Int?
    let reactions: [String: Int]?
    let publishers: [Developer]?
    let tags: [Tag]?
    let added: Int?
    let platforms: [PlatformInfo]?
    let playtime, screenshotsCount, moviesCount, creatorsCount: Int?
    let achievementsCount, parentAchievementsCount: Int?
    let redditURL: String?
    let genres: [Genre]?
    let redditName, redditDescription, redditLogo: String?
    let redditCount, twitchCount, youtubeCount, reviewsTextCount: Int?
    let suggestionsCount: Int?
    let alternativeNames: [String]?
    let metacriticURL: String?
    let parentsCount, additionsCount, gameSeriesCount: Int?
    let reviewsCount: Int?
    let saturatedColor, dominantColor: String?
    let stores: [Store]?
    let descriptionRaw: String?

    enum CodingKeys: String, CodingKey {
        case id, slug, name
        case nameOriginal = "name_original"
        case description, metacritic
        case metacriticPlatforms = "metacritic_platforms"
        case released, tba, updated
        case backgroundImage = "background_image"
        case backgroundImageAdditional = "background_image_additional"
        case website, rating
        case ratingTop = "rating_top"
        case reactions, added
        case playtime, platforms, publishers, tags
        case genres
        case screenshotsCount = "screenshots_count"
        case moviesCount = "movies_count"
        case creatorsCount = "creators_count"
        case achievementsCount = "achievements_count"
        case parentAchievementsCount = "parent_achievements_count"
        case redditURL = "reddit_url"
        case redditName = "reddit_name"
        case redditDescription = "reddit_description"
        case redditLogo = "reddit_logo"
        case redditCount = "reddit_count"
        case twitchCount = "twitch_count"
        case youtubeCount = "youtube_count"
        case reviewsTextCount = "reviews_text_count"
        case suggestionsCount = "suggestions_count"
        case alternativeNames = "alternative_names"
        case metacriticURL = "metacritic_url"
        case parentsCount = "parents_count"
        case additionsCount = "additions_count"
        case gameSeriesCount = "game_series_count"
        case reviewsCount = "reviews_count"
        case saturatedColor = "saturated_color"
        case dominantColor = "dominant_color"
        case stores
        case descriptionRaw = "description_raw"
    }
}

// MARK: - Genre
struct Genre: Decodable {
  let id: Int?
  let name, slug: String?
  let imageBackground: String?

  enum CodingKeys: String, CodingKey {
    case id, name, slug
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

struct Tag: Decodable {
  let name: String?
}

// MARK: - MetacriticPlatform
struct MetacriticPlatform: Decodable {
    let metascore: Int?
    let url: String?
    let platform: MetacriticPlatformDetail?
}

// MARK: - MetacriticPlatformDetail
struct MetacriticPlatformDetail: Decodable {
    let platform: Int?
    let name, slug: String?
}

// MARK: - Store
struct Store: Decodable {
    let id: Int?
    let url: String?
}




