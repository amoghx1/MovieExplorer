//
//  MEMovieDetailModel.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 22/06/25.
//

import UIKit
import Foundation

struct MEMovieDetailResponseModel: Codable {
    let genres: [Genre]
    let homepage: String?
    let id: Int?
    let voteAverage: Double?
    let voteCount: Int?
    let runtime: Int?

    enum CodingKeys: String, CodingKey {
        case genres
        case homepage
        case id
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case runtime
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}

