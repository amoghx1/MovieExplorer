//
//  ViewController.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 19/06/25.
//

import UIKit

class HomeViewController: UIViewController {

    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"
        setupCollectionView()
        setupActivityIndicator()
        setupViewModel()
        viewModel.fetchMovies()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
    }

    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    private func setupViewModel() {
        viewModel.onMoviesUpdated = { [weak self] in
            self?.collectionView.reloadData()
        }

        viewModel.onError = { error in
            print("Error fetching movies:", error)
        }

        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
        }
    }

    @objc private func refreshMovies() {
        viewModel.refreshMovies()
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfMovies
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            fatalError("cv cell issue")
        }
        let movie = viewModel.movie(at: indexPath)
        let isFavourite = viewModel.isFavouriteMovie(at: indexPath)
        cell.configure(with: movie, isFavourite: isFavourite)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movie(at: indexPath)
        let detailVC = MovieDetailViewController.instantiate(with: selectedMovie, delegate: self)
        detailVC?.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .automatic : .popover
        if let detailVC = detailVC {
            present(detailVC, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width
        let minColumnWidth: CGFloat = 160
        let columns = max(Int(collectionWidth / minColumnWidth), 2)
        let spacing: CGFloat = 12 * CGFloat(columns - 1)
        let width = (collectionWidth - spacing) / CGFloat(columns)
        return CGSize(width: width, height: width * 1.5)
    }
}

extension HomeViewController: detailVCDelegate {
    func didUpdateFavourites() {
        self.collectionView.reloadData()
    }
}
