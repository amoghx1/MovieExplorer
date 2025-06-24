//
//  HomePageResponseModel.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 23/06/25.
//

import Foundation


struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
    let title: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let rating: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case rating = "vote_average"
    }
}

