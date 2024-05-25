//
//  GameTrailer.swift
//  Game Box
//
//  Created by alihizardere on 25.05.2024.
//

import Foundation

// MARK: - GameTrailerResponse
struct GameTrailerResponse: Decodable {
    let results: [TrailerResult]?
}

// MARK: - TrailerResult
struct TrailerResult: Decodable {
    let id: Int?
    let name: String?
    let data: Trailer?
}

// MARK: - Trailer
struct Trailer: Decodable {
    let the480, max: String?

    enum CodingKeys: String, CodingKey {
        case the480 = "480"
        case max
    }
}
