//
//  APIManager.swift
//  MovieExplorer
//
//  Created by Amogh Raut on 19/06/25.
//
 
import UIKit

class APIManager {
    static let shared = APIManager()

    func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = NetworkPath.Endpoint.trendingMovies().url() else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }

            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func getMovieDetails(movieID: Int, completion: @escaping (Result<MEMovieDetailResponseModel, Error>) -> Void) {
        guard let url = NetworkPath.Endpoint.movieDetails(id: movieID).url() else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }

            do {
                let movie = try JSONDecoder().decode(MEMovieDetailResponseModel.self, from: data)
                completion(.success(movie))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func searchMovies(query: String, page: Int = 1, completion: @escaping (Result<[Movie], Error>) -> Void) {
        guard let url = NetworkPath.Endpoint.searchMovies(query: query, page: page).url() else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1)))
                return
            }

            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
