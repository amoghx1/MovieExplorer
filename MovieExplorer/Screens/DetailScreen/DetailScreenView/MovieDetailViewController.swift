//
//  MovieDetailViewController.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 23/06/25.
//

import UIKit
import CoreData

protocol detailVCDelegate: AnyObject {
    func didUpdateFavourites()
}

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var favouritesButton: UIButton!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var redirectButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
   
    private var viewModel: MovieDetailViewModel!
    weak var delegate: detailVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        setupButton()
        setupViewModel()
        configureUI()
        viewModel.fetchMovieDetails()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.didUpdateFavourites()
    }
    
    static func instantiate(with movie: Movie, delegate: detailVCDelegate? = nil) -> MovieDetailViewController? {
        let vc = MovieDetailViewController(nibName: "MovieDetailViewController", bundle: nil)
        vc.viewModel = MovieDetailViewModel(movie: movie)
        vc.delegate = delegate
        return vc
    }

    private func setupViewModel() {
        viewModel.onDetailsLoaded = { [weak self] in
            self?.updateDetailsUI()
        }
        
        viewModel.onFavouriteStateChanged = { [weak self] isFav in
            self?.updateFavouriteButton(isFav)
        }
    }

    private func configureUI() {
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
        yearLabel.text = viewModel.year
        
        if let url = viewModel.posterURL {
            posterImageView.kf.setImage(with: url)
        }
        
        updateFavouriteButton(viewModel.isFavourite)
        
        ratingLabel.layer.cornerRadius = 6
        yearLabel.layer.cornerRadius = 6
        durationLabel.layer.cornerRadius = 6
        
        ratingLabel.clipsToBounds = true
        durationLabel.clipsToBounds = true
        yearLabel.clipsToBounds = true
    }
    
    private func updateDetailsUI() {
        durationLabel.text = viewModel.duration
        
        if let rating = viewModel.rating {
            ratingLabel.text = rating
            ratingLabel.isHidden = false
        } else {
            ratingLabel.isHidden = true
        }
        
        genresLabel.text = viewModel.genres
    }
    
    private func updateFavouriteButton(_ isFav: Bool) {
        favouritesButton.setTitle(isFav ? "Remove from Favourites" : "Mark as Favourite", for: .normal)
        favouritesButton.backgroundColor = isFav ? .darkGray : .systemRed
    }
    
    // MARK: - Actions
    private func setupButton() {
        favouritesButton.layer.cornerRadius = 20
        redirectButton.layer.cornerRadius = 20
        
        favouritesButton.addTarget(self, action: #selector(toggleFavourite), for: .touchUpInside)
        crossButton.addTarget(self, action: #selector(crossButtonTapped), for: .touchUpInside)
        redirectButton.addTarget(self, action: #selector(redirectButtonTapped), for: .touchUpInside)
    }
    
    @objc private func toggleFavourite() {
        viewModel.toggleFavourite()
    }
    
    @objc private func crossButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func redirectButtonTapped() {
        if let url = viewModel.homepageURL {
            UIApplication.shared.open(url)
        }
    }
    
    // MARK: - Blur Background
    private func setupBackgroundView() {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.backgroundColor = .clear
        backgroundView.addSubview(blurView)
        backgroundView.sendSubviewToBack(blurView)
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor)
        ])
    }
}
