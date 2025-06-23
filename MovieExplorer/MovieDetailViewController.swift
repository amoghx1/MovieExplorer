//
//  MovieDetailViewController.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 23/06/25.
//

import UIKit
import CoreData

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    
    
    var movie: Movie?
    private let repository = MovieRepository()
    weak var delegate: detailVCDelegate?
    
    private var isFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        configureScreen(movie: movie)
        setupButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didUpdateFavourites()
    }
    
    static func instantiate(with movie: Movie, delegate: detailVCDelegate? = nil) -> MovieDetailViewController? {
        
        let viewController = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        viewController.movie = movie
        viewController.delegate = delegate
        return viewController
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
                print("❌ Failed to fetch movie details:", error)
            }
        }
    }
    
    private func setupButton() {
        favouritesButton.layer.cornerRadius = 25
        favouritesButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
    }
    
    private func updateUI(with movie: Movie) {
        titleLabel.text = movie.title ?? "No Title"
        overviewLabel.text = movie.overview ?? "No Overview Available"
        
        if let releaseDate = movie.releaseDate {
            yearLabel.text = String(releaseDate.prefix(4))
        } else {
            yearLabel.text = ""
        }
        
        if let posterPath = movie.posterPath {
            let urlString = "https://image.tmdb.org/t/p/w500\(posterPath)"
            posterImageView.kf.setImage(with: URL(string: urlString))
        }

    }
    
    private func updateFavouriteButtonAppearance() {
        if isFavourite {
            favouritesButton.setTitle("Remove from Favourites", for: .normal)
            favouritesButton.backgroundColor = .systemGray
        } else {
            favouritesButton.setTitle("Mark as Favourite", for: .normal)
            favouritesButton.backgroundColor = .systemRed
        }
    }
    
    @objc private func toggleFavourite() {
        isFavourite.toggle()
        
        if isFavourite {
            addToFavourites()
        } else {
            removeFromFavourites()
        }
        
        updateFavouriteButtonAppearance()
    }
    
    @objc private func crossButtonTapped() {
        dismiss(animated: true)
    }
    
    private func addToFavourites() {
        guard let movie = movie else { return }
        
        repository.save(movie: movie) { result in
            switch result {
            case .success:
                print("CD: Movie saved to favourites.")
            case .failure(let error):
                print("CD: Failed to save movie:", error)
            }
        }
    }
    
    private func removeFromFavourites() {
        guard let movie = movie else { return }
        
        repository.deleteMovie(withID: movie.id) { result in
            switch result {
            case .success:
                print("CD: Movie removed from favourites.")
            case .failure(let error):
                print("CD: Failed to remove movie:", error)
            }
        }
    }
    
    
    private func setupBackgroundView() {
        // Replace backgroundView's backgroundColor with blur effect
        let blurEffect = UIBlurEffect(style: .systemMaterialDark) // or choose style you want
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.layer.cornerRadius = 20
        blurEffectView.clipsToBounds = true

        backgroundView.backgroundColor = .clear
        backgroundView.addSubview(blurEffectView)
        backgroundView.sendSubviewToBack(blurEffectView)
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        ])
        
        backgroundView.layer.cornerRadius = 20
        backgroundView.clipsToBounds = true
    }


}
