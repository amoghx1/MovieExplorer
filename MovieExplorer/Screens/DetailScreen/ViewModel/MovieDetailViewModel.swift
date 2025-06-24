//
//  MovieDetailViewModel.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 23/06/25.
//

import Foundation

import Foundation

final class MovieDetailViewModel {

    var movie: Movie
    var movieDetails: MEMovieDetailResponseModel?
    private let repository: MovieRepository

    var onDetailsLoaded: (() -> Void)?
    var onFavouriteStateChanged: ((Bool) -> Void)?

    private(set) var isFavourite: Bool {
        didSet {
            onFavouriteStateChanged?(isFavourite)
        }
    }

    init(movie: Movie, repository: MovieRepository = MovieRepository()) {
        self.movie = movie
        self.repository = repository
        self.isFavourite = repository.isMovieSaved(id: movie.id)
    }

    func fetchMovieDetails() {
        APIManager.shared.getMovieDetails(movieID: movie.id) { [weak self] result in
            switch result {
            case .success(let details):
                self?.movieDetails = details
                DispatchQueue.main.async {
                    self?.onDetailsLoaded?()
                }
            case .failure(let error):
                print("Failed to fetch movie details:", error)
            }
        }
    }

    func toggleFavourite() {
        isFavourite.toggle()

        if isFavourite {
            repository.save(movie: movie) { result in
                if case .failure(let error) = result {
                    print("Failed to save favourite:", error)
                } else {
                    ToastManager.show(message: ToastMessages.addedToFavourites.rawValue)
                }
            }
        } else {
            repository.deleteMovie(withID: movie.id) { result in
                if case .failure(let error) = result {
                    print("Failed to remove favourite:", error)
                } else {
                    ToastManager.show(message: ToastMessages.removedFromFavourites.rawValue)
                }
            }
        }
    }

    var title: String {
        movie.title ?? "No Title"
    }

    var overview: String {
        movie.overview ?? "No Overview Available"
    }

    var year: String {
        guard let date = movie.releaseDate else { return "" }
        return String(date.prefix(4))
    }

    var posterURL: URL? {
        guard let path = movie.posterPath else { return nil }
        return MEUtility.getImageURL(path: path)
    }

    var duration: String {
        guard let minutes = movieDetails?.runtime else { return "--" }
        return MEUtility.getHoursMins(minutes: minutes)
    }

    var rating: String? {
        guard let avg = movieDetails?.voteAverage, avg > 0 else { return nil }
        return String(format: "%.1f/10", avg)
    }

    var genres: String {
        movieDetails?.genres
            .compactMap(\.name)
            .prefix(4)
            .joined(separator: ", ") ?? ""
    }

    var homepageURL: URL? {
        guard let homepage = movieDetails?.homepage else { return nil }
        return URL(string: homepage)
    }
}

