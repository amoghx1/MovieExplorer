//
//  MovieCollectionViewCell.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 22/06/25.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let overlayView = UIView()
    private let titleLabel = UILabel()
    private let heartImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Image View Setup
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        
        // Gradient Overlay Setup
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.isUserInteractionEnabled = false
        contentView.addSubview(overlayView)
        applyGradient(to: overlayView)
        
        // Title Label Setup
        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(titleLabel)
        
        // Heart Icon Setup
        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.image = UIImage(systemName: "heart.fill")
        heartImageView.tintColor = .systemRed
        contentView.addSubview(heartImageView)
        heartImageView.isHidden = true // default hidden

        // Corner Radius
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        // Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            overlayView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            overlayView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -4),
            
            heartImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            heartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heartImageView.widthAnchor.constraint(equalToConstant: 24),
            heartImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configure Methods

    func configure(with movie: Movie) {
        titleLabel.text = movie.title ?? "No Title"
        if let path = movie.posterPath,
           let url = MEUtility.getImageURL(path: path) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = nil
        }
    }

    func configure(with movie: CDMovie) {
        titleLabel.text = movie.title ?? "No Title"
        if let data = movie.posterImageData {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }

    func configure(with movie: Movie, isFavourite: Bool) {
        configure(with: movie)
        heartImageView.isHidden = !isFavourite
    }

    // MARK: - Gradient Layer

    private func applyGradient(to view: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor
        ]
        gradient.locations = [0.0, 0.2, 0.8, 1.0]
        gradient.frame = bounds
        gradient.cornerRadius = 12
        view.layer.insertSublayer(gradient, at: 0)
        view.layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.layer.sublayers?.first?.frame = overlayView.bounds
    }
}
