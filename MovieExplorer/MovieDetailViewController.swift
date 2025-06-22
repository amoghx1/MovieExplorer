//
//  MovieDetailViewController.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 19/06/25.
//
import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    var movie: Movie?
    private let repository = MovieRepository()

    private let backgroundImageView = UIImageView()
    private let titleBlurContainer = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let overviewBlurContainer = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favouriteButton = UIButton(type: .system)

    private var isFavourite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        configureScreen(movie: movie)
    }

    // MARK: - External Configuration
    func configureScreen(movie: Movie?) {
        guard let movieID = movie?.id else { return }
        self.movie = movie

        // Check if this movie is already saved in Core Data
        isFavourite = repository.isMovieSaved(id: movieID)
        updateFavouriteButtonAppearance()

        APIManager.shared.getMovieDetails(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                DispatchQueue.main.async {
                    self?.movie = movieDetails
                    self?.updateUI(with: movieDetails)

                    // Re-check in case new data changed ID (unlikely but safe)
                    self?.isFavourite = self?.repository.isMovieSaved(id: movieDetails.id) ?? false
                    self?.updateFavouriteButtonAppearance()
                }
            case .failure(let error):
                print("  Failed to fetch movie details:", error)
            }
        }
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)

        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        // Title Blur & Label
        titleBlurContainer.translatesAutoresizingMaskIntoConstraints = false
        titleBlurContainer.layer.cornerRadius = 16
        titleBlurContainer.clipsToBounds = true
        view.addSubview(titleBlurContainer)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 26)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleBlurContainer.contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleBlurContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleBlurContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleBlurContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: titleBlurContainer.contentView.topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: titleBlurContainer.contentView.bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: titleBlurContainer.contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: titleBlurContainer.contentView.trailingAnchor, constant: -16)
        ])

        // Overview Blur & Label
        overviewBlurContainer.translatesAutoresizingMaskIntoConstraints = false
        overviewBlurContainer.layer.cornerRadius = 16
        overviewBlurContainer.clipsToBounds = true
        view.addSubview(overviewBlurContainer)

        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.font = UIFont.systemFont(ofSize: 15)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 0
        overviewLabel.textAlignment = .left
        overviewBlurContainer.contentView.addSubview(overviewLabel)

        NSLayoutConstraint.activate([
            overviewBlurContainer.topAnchor.constraint(equalTo: titleBlurContainer.bottomAnchor, constant: 20),
            overviewBlurContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            overviewBlurContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            overviewLabel.topAnchor.constraint(equalTo: overviewBlurContainer.contentView.topAnchor, constant: 16),
            overviewLabel.bottomAnchor.constraint(equalTo: overviewBlurContainer.contentView.bottomAnchor, constant: -16),
            overviewLabel.leadingAnchor.constraint(equalTo: overviewBlurContainer.contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: overviewBlurContainer.contentView.trailingAnchor, constant: -16)
        ])

        // Favourite Button
        favouriteButton.setTitleColor(.white, for: .normal)
        favouriteButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        favouriteButton.layer.cornerRadius = 12
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        view.addSubview(favouriteButton)

        NSLayoutConstraint.activate([
            favouriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            favouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            favouriteButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    // MARK: - UI Updates
    private func updateUI(with movie: Movie) {
        titleLabel.text = movie.title ?? "No Title"
        overviewLabel.text = movie.overview ?? "No Overview Available"

        if let posterPath = movie.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            backgroundImageView.kf.setImage(with: URL(string: urlString))
        }
    }

    private func updateFavouriteButtonAppearance() {
        if isFavourite {
            favouriteButton.setTitle("Remove from Favourites", for: .normal)
            favouriteButton.backgroundColor = UIColor.systemGray.withAlphaComponent(0.85)
        } else {
            favouriteButton.setTitle("Add to Favourites", for: .normal)
            favouriteButton.backgroundColor = UIColor.systemPink.withAlphaComponent(0.85)
        }
    }

    // MARK: - Favourite Logic
    @objc private func toggleFavourite() {
        isFavourite.toggle()

        if isFavourite {
            addToFavourites()
        } else {
            removeFromFavourites()
        }

        updateFavouriteButtonAppearance()
    }

    private func addToFavourites() {
        guard let movie = movie else { return }

        repository.save(movie: movie) { result in
            switch result {
            case .success:
                print("⭐️ Movie saved to favourites.")
            case .failure(let error):
                print("  Failed to save movie:", error)
            }
        }
    }

    private func removeFromFavourites() {
        guard let movie = movie else { return }

        repository.deleteMovie(withID: movie.id) { result in
            switch result {
            case .success:
                print("🗑️ Movie removed from favourites.")
            case .failure(let error):
                print("  Failed to remove movie:", error)
            }
        }
    }
}
