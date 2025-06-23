//
//  APIManager.swift
//  MovieExplorer
//
//  Created by Amogh Raut on 19/06/25.
//
 
import UIKit

class APIManager {
    static let shared = APIManager() // Singleton for easy access

    private let imageCache = NSCache<NSString, UIImage>()

    func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let apiKey = "605b64f9978f0c69d58a60988f9a7804"
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey)") else {
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

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, let image = UIImage(data: data), error == nil else {
                completion(nil)
                return
            }

            self?.imageCache.setObject(image, forKey: url.absoluteString as NSString)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    func getMovieDetails(movieID: Int, completion: @escaping (Result<MEMovieDetailResponseModel, Error>) -> Void) {
        let apiKey = "605b64f9978f0c69d58a60988f9a7804"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)") else {
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
    
    //https://api.themoviedb.org/3/search/movie?query=elio&page=1&language=en-US&api_key=605b64f9978f0c69d58a60988f9a7804
}
