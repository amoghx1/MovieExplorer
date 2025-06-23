//
//  MovieDetailViewController.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 19/06/25.
//
import UIKit
import Kingfisher

protocol detailVCDelegate: AnyObject {
    func didUpdateFavourites()
}


class MovieDetailViewController: UIViewController {
    var movie: Movie?
    private let repository = MovieRepository()
    weak var delegate: detailVCDelegate?

    private let backgroundImageView = UIImageView()
    private let infoBlurContainer = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
    private let titleLabel = UILabel()
    private let yearLabel = UILabel()
    private let overviewLabel = UILabel()
    private let favouriteButton = UIButton(type: .system)

    private var isFavourite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        configureScreen(movie: movie)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didUpdateFavourites()
    }

    func configureScreen(movie: Movie?) {
        guard let movieID = movie?.id else { return }
        self.movie = movie

        isFavourite = repository.isMovieSaved(id: movieID)
        updateFavouriteButtonAppearance()

        APIManager.shared.getMovieDetails(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let movieDetails):
                DispatchQueue.main.async {
                    self?.movie = movieDetails
                    self?.updateUI(with: movieDetails)

                    self?.isFavourite = self?.repository.isMovieSaved(id: movieDetails.id) ?? false
                    self?.updateFavouriteButtonAppearance()
                }
            case .failure(let error):
                print("  Failed to fetch movie details:", error)
            }
        }
    }

    private func setupUI() {
        // Background Image
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

        // Favourite Button
        favouriteButton.setTitleColor(.white, for: .normal)
        favouriteButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        favouriteButton.layer.cornerRadius = 24
        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        view.addSubview(favouriteButton)

        NSLayoutConstraint.activate([
            favouriteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            favouriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            favouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            favouriteButton.heightAnchor.constraint(equalToConstant: 48)
        ])

        infoBlurContainer.translatesAutoresizingMaskIntoConstraints = false
        infoBlurContainer.layer.cornerRadius = 16
        infoBlurContainer.clipsToBounds = true
        view.addSubview(infoBlurContainer)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        infoBlurContainer.contentView.addSubview(titleLabel)

        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        yearLabel.textColor = .systemYellow
        yearLabel.textAlignment = .right
        yearLabel.setContentHuggingPriority(.required, for: .horizontal)
        yearLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        infoBlurContainer.contentView.addSubview(yearLabel)

        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        overviewLabel.font = UIFont.systemFont(ofSize: 15)
        overviewLabel.textColor = .white
        overviewLabel.numberOfLines = 0
        overviewLabel.textAlignment = .left
        infoBlurContainer.contentView.addSubview(overviewLabel)

        // Constraints
        NSLayoutConstraint.activate([
            infoBlurContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            infoBlurContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            infoBlurContainer.bottomAnchor.constraint(equalTo: favouriteButton.topAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: infoBlurContainer.contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: infoBlurContainer.contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: yearLabel.leadingAnchor, constant: -8),

            yearLabel.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: infoBlurContainer.contentView.trailingAnchor, constant: -16),
            yearLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 8),

            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            overviewLabel.leadingAnchor.constraint(equalTo: infoBlurContainer.contentView.leadingAnchor, constant: 16),
            overviewLabel.trailingAnchor.constraint(equalTo: infoBlurContainer.contentView.trailingAnchor, constant: -16),
            overviewLabel.bottomAnchor.constraint(equalTo: infoBlurContainer.contentView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - UI Updates
    private func updateUI(with movie: Movie) {
        titleLabel.text = movie.title ?? "No Title"
        overviewLabel.text = movie.overview ?? "No Overview Available"

        if let releaseDate = movie.releaseDate {
            let year = String(releaseDate.prefix(4))
            yearLabel.text = year
        } else {
            yearLabel.text = ""
        }

        if let posterPath = movie.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            backgroundImageView.kf.setImage(with: URL(string: urlString))
        }
    }

    private func updateFavouriteButtonAppearance() {
        if isFavourite {
            favouriteButton.setTitle("Remove from Favourites", for: .normal)
            favouriteButton.backgroundColor = UIColor.systemGray
        } else {
            favouriteButton.setTitle("Mark as Favourite", for: .normal)
            favouriteButton.backgroundColor = UIColor.systemRed
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
                print("Movie removed from favourites.")
            case .failure(let error):
                print("  Failed to remove movie:", error)
            }
        }
    }
}

