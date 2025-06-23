//
//  FavouritesViewController.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 22/06/25.
//
import UIKit

class FavouritesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var collectionView: UICollectionView!
    private var savedMovies: [CDMovie] = []
    private let repository = MovieRepository()

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No favourites yet"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favourites"

        setupCollectionView()
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchSavedMovies()
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }

    private func fetchSavedMovies() {
        savedMovies = repository.fetchAllMovies()
        emptyLabel.isHidden = !savedMovies.isEmpty
        collectionView.reloadData()
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMovies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            fatalError("  Could not dequeue MovieCell")
        }

        let cdMovie = savedMovies[indexPath.item]
        cell.configure(with: cdMovie) // ✅ Uses CDMovie version of configure()
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = savedMovies[indexPath.item]
        
//        let detailVC = MovieDetailViewControllerProgrammatic() 
//        detailVC.configureScreen(movie: selectedMovie.toMovie())
//        detailVC.modalPresentationStyle = .popover
//        detailVC.delegate = self
//
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            detailVC.modalPresentationStyle = .automatic
//        }
//
//        present(detailVC, animated: true)
        
        if let detailVC = MovieDetailViewController.instantiate(with: selectedMovie.toMovie(), delegate: self) {
            detailVC.modalPresentationStyle = .popover

            if UIDevice.current.userInterfaceIdiom == .pad {
                detailVC.modalPresentationStyle = .automatic
            }

            present(detailVC, animated: true)
        }

    }

}

extension FavouritesViewController : detailVCDelegate {
    func didUpdateFavourites() {
        fetchSavedMovies()
    }
    
}
