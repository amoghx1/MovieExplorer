//
//  HomeViewModel.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 24/06/25.
//

import Foundation

final class HomeViewModel {

    private let repository: MovieRepository
    private(set) var movies: [Movie] = [] {
        didSet {
            onMoviesUpdated?()
        }
    }

    var onMoviesUpdated: (() -> Void)?
    var onError: ((Error) -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?

    // MARK: - Init
    init(repository: MovieRepository = MovieRepository()) {
        self.repository = repository
    }

    // MARK: - Methods
    func fetchMovies() {
        onLoadingStateChanged?(true)
        APIManager.shared.getMovies { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChanged?(false)
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    self?.onError?(error)
                    let errorMessage = (error as? APIError)?.errorDescription ?? ToastMessages.couldntLoadPage.rawValue
                    ToastManager.show(message: errorMessage)
                }
            }
        }
    }

    func refreshMovies() {
        onLoadingStateChanged?(true)
        APIManager.shared.getMovies { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChanged?(false)
                switch result {
                case .success(let movies):
                    self?.movies = movies
                case .failure(let error):
                    self?.onError?(error)
                    let errorMessage = (error as? APIError)?.errorDescription ?? ToastMessages.couldntLoadPage.rawValue
                    ToastManager.show(message: errorMessage)
                }
            }
        }
    }

    func movie(at indexPath: IndexPath) -> Movie {
        return movies[indexPath.item]
    }

    func isFavouriteMovie(at indexPath: IndexPath) -> Bool {
        let movie = movies[indexPath.item]
        return repository.isMovieSaved(id: movie.id)
    }

    var numberOfMovies: Int {
        return movies.count
    }
}

