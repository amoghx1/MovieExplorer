//
//  APIExectutor.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 25/06/25.
//

import UIKit

extension APIManager {
    
    func performRequest<T: Decodable>(
        url: URL,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                completion(.failure(APIError.noInternet))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(APIError.serverError(code: -1)))
                return
            }

            if let error = error {
                completion(.failure(APIError.serverError(code: httpResponse.statusCode)))
                return
            }

            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }

            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(APIError.decodingError))
            }

        }.resume()
    }
    
}
