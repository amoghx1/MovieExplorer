//
//  ViewController.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 19/06/25.
//

import UIKit
import Kingfisher


class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView!
    private var movies: [Movie] = []
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Home"

        setupCollectionView()
        fetchMovies()
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

    private func fetchMovies() {
        let activity = UIActivityIndicatorView(style: .large)
        activity.center = view.center
        view.addSubview(activity)
        activity.startAnimating()

        getMovies { [weak self] result in
            DispatchQueue.main.async {
                activity.stopAnimating()
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("  Error fetching movies:", error)
                }
            }
        }
    }

    @objc private func refreshMovies() {
        getMovies { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.collectionView.reloadData()
                case .failure(let error):
                    print("  Refresh error:", error)
                }
            }
        }
    }

    // MARK: - CollectionView DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            fatalError("Could not dequeue MovieCell")
        }
        cell.configure(with: movies[indexPath.item])
        return cell
    }

    // MARK: - CollectionView Delegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = MovieDetailViewController()
        detailVC.configureScreen(movie: movies[indexPath.item])
        detailVC.modalPresentationStyle = .popover
        if UIDevice().userInterfaceIdiom == .pad {
            detailVC.modalPresentationStyle = .automatic
        }
        present(detailVC, animated: true)
    }

    // MARK: - Layout for iPad/iPhone

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

    // MARK: - API Call

    private func getMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let apiKey = "605b64f9978f0c69d58a60988f9a7804"
        let dayOrWeek = ["day", "week"].randomElement()!
        guard let url = URL(string: "https://api.themoviedb.org/3/trending/movie/\(dayOrWeek)?api_key=\(apiKey)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(decoded.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}


class MovieCell: UICollectionViewCell {
    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
        //        // Optional: Add a slight shadow to the cell itself (outside contentView)
        //        layer.shadowColor = UIColor.black.cgColor
        //        layer.shadowOpacity = 0.15
        //        layer.shadowOffset = CGSize(width: 0, height: 2)
        //        layer.shadowRadius = 4
        //        layer.masksToBounds = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        guard let path = movie.posterPath else {
            imageView.image = nil
            return
        }

        let urlString = "https://image.tmdb.org/t/p/w500\(path)"
        guard let url = URL(string: urlString) else {
            imageView.image = nil
            return
        }

        imageView.kf.setImage(with: url)
    }
    
    func configure(with movie: CDMovie) {
        if let data = movie.posterImageData {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = UIImage(systemName: "photo") // fallback
        }
    }

}



//class FavouritesViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        title = "Favourites"
//
//        // For now, a placeholder label
//        let label = UILabel()
//        label.text = "No favourites yet"
//        label.textAlignment = .center
//        label.textColor = .gray
//        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//
//        view.addSubview(label)
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//}

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = MainViewController()
        homeVC.title = "Home"
        homeVC.tabBarItem = UITabBarItem(title: "HOME", image: UIImage(systemName: "house"), tag: 0)

        let favVC = FavouritesViewController()
        favVC.title = "Favourites"
        favVC.tabBarItem = UITabBarItem(title: "FAVOURITES", image: UIImage(systemName: "heart"), tag: 1)

        let homeNav = UINavigationController(rootViewController: homeVC)
        let favNav = UINavigationController(rootViewController: favVC)

        viewControllers = [homeNav, favNav]

        makeTabBarTransparent()
    }

    private func makeTabBarTransparent() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8) // Lightly translucent white

        // Optional: Remove shadow (top line)
        appearance.shadowImage = nil
        appearance.shadowColor = nil

        tabBar.standardAppearance = appearance

        // For iOS 15+ (to affect scroll edge appearance as well)
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}

