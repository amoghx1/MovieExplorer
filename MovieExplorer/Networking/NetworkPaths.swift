//
//  NetworkPaths.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 24/06/25.
//

import Foundation

enum NetworkPath {
    static let baseURL = "https://api.themoviedb.org/3"
    static let apiKey = "605b64f9978f0c69d58a60988f9a7804"

    enum Endpoint {
        case trendingMovies(timeWindow: String = "day")
        case movieDetails(id: Int)
        case searchMovies(query: String, page: Int = 1)

        var path: String {
            switch self {
            case .trendingMovies(let timeWindow):
                return "/trending/movie/\(timeWindow)"
            case .movieDetails(let id):
                return "/movie/\(id)"
            case .searchMovies:
                return "/search/movie"
            }
        }

        var queryItems: [URLQueryItem] {
            switch self {
            case .searchMovies(let query, let page):
                return [
                    URLQueryItem(name: "query", value: query),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "language", value: "en-US"),
                    URLQueryItem(name: "api_key", value: NetworkPath.apiKey)
                ]
            default:
                return [URLQueryItem(name: "api_key", value: NetworkPath.apiKey)]
            }
        }

        func url() -> URL? {
            var components = URLComponents(string: NetworkPath.baseURL + path)
            components?.queryItems = queryItems
            return components?.url
        }
    }
}
