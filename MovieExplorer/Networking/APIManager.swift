//
//  APIManager.swift
//  MovieExplorer
//
//  Created by Amogh Raut on 19/06/25.
//
 
import UIKit

class APIManager {
    static let shared = APIManager()

    // MARK: - Public API Methods

    func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = NetworkPath.Endpoint.trendingMovies().url() else {
            completion(.failure(APIError.invalidURL))
            return
        }

        performRequest(url: url, completion: { (result: Result<MovieResponse, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func getMovieDetails(movieID: Int, completion: @escaping (Result<MEMovieDetailResponseModel, Error>) -> Void) {
        guard let url = NetworkPath.Endpoint.movieDetails(id: movieID).url() else {
            completion(.failure(APIError.invalidURL))
            return
        }

        performRequest(url: url, completion: completion)
    }

    //    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
    //        guard let url = NetworkPath.Endpoint.searchMovies(query: query, page: page).url() else {
    //            completion(.failure(APIError.invalidURL))
    //            return
    //        }
    //
    //        let request = URLRequest(url: url)
    //        URLSession.shared.dataTask(with: request) { data, response, error in
    //
    //
    //            if let error = error {
    //                completion(.failure(error))
    //                return
    //            }
    //
    //            guard let data = data else {
    //                completion(.failure(APIError.noData))
    //                return
    //            }
    //
    //            do {
    //                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
    //                completion(.success(movieResponse.results))
    //            } catch {
    //                completion(.failure(APIError.decodingError))
    //            }
    //        }.resume()
    //    }
    
}
