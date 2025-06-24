//
//  MovieRepository.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 22/06/25.
//

import Foundation
import CoreData

protocol MovieRepositoryProtocol {
    func fetchAllMovies() -> [CDMovie]
    func save(movie: Movie, imageData: Data?)
    func delete(movie: CDMovie)
}

final class MovieRepository: MovieRepositoryProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchAllMovies() -> [CDMovie] {
        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("  Fetch error: \(error)")
            return []
        }
    }

    func save(movie: Movie, imageData: Data?) {
        let cdMovie = CDMovie(context: context)
        cdMovie.id = Int32(movie.id)
        cdMovie.title = movie.title
        cdMovie.overview = movie.overview
        cdMovie.posterPath = movie.posterPath
        cdMovie.releaseDate = movie.releaseDate
        cdMovie.posterImageData = imageData

        do {
            try context.save()
        } catch {
            print("  Save error: \(error)")
        }
    }

    func delete(movie: CDMovie) {
        context.delete(movie)
        do {
            try context.save()
        } catch {
            print("  Delete error: \(error)")
        }
    }
    
    
    func isMovieSaved(id: Int) -> Bool {
        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        request.fetchLimit = 1

        do {
            return try context.count(for: request) > 0
        } catch {
            print("  Error checking saved movie:", error)
            return false
        }
    }

    func save(movie: Movie, completion: @escaping (Result<Void, Error>) -> Void) {
        let cdMovie = CDMovie(context: context)
        cdMovie.id = Int32(movie.id)
        cdMovie.title = movie.title
        cdMovie.overview = movie.overview
        cdMovie.posterPath = movie.posterPath
        cdMovie.releaseDate = movie.releaseDate

        if let posterPath = movie.posterPath {
            if let url = MEUtility.getImageURL(path: posterPath) {
                URLSession.shared.dataTask(with: url) { data, _, _ in
                    DispatchQueue.main.async {
                        cdMovie.posterImageData = data
                        do {
                            try self.context.save()
                            completion(.success(()))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                }.resume()
                return
            }
        }

        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    // MARK: - Delete movie
    func deleteMovie(withID id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let request: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(request)
            results.forEach { context.delete($0) }
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
}

