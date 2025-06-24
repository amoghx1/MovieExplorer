//
//  FavouritesViewModel.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 23/06/25.
//

import Foundation

final class FavouritesViewModel {

    private let repository: MovieRepository
    private(set) var savedMovies: [CDMovie] = [] {
        didSet {
            onDataChanged?()
        }
    }

    var onDataChanged: (() -> Void)?
    var onEmptyStateChanged: ((Bool) -> Void)?

    // MARK: - Init
    init(repository: MovieRepository = MovieRepository()) {
        self.repository = repository
    }

    // MARK: - Methods
    func fetchSavedMovies() {
        savedMovies = repository.fetchAllMovies()
        onDataChanged?()
        onEmptyStateChanged?(savedMovies.isEmpty)
    }

    var numberOfItems: Int {
        return savedMovies.count
    }

    func movie(at indexPath: IndexPath) -> CDMovie {
        return savedMovies[indexPath.item]
    }
}
