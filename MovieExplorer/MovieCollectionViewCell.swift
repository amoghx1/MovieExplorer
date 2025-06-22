//
//  MovieCollectionViewCell.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 22/06/25.
//

import UIKit
import CoreData

class MovieCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let titleOverlay = UIView()
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        titleOverlay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleOverlay)
        applyGradient(to: titleOverlay)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .left
        titleOverlay.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleOverlay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleOverlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleOverlay.heightAnchor.constraint(equalToConstant: 80),

            titleLabel.leadingAnchor.constraint(equalTo: titleOverlay.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titleOverlay.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: titleOverlay.bottomAnchor, constant: -4)
        ])

        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with movie: Movie) {
        titleLabel.text = movie.title ?? "No Title"

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
        titleLabel.text = movie.title ?? "No Title"

        if let data = movie.posterImageData {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }

    private func applyGradient(to view: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.9).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.frame = bounds
        gradient.cornerRadius = 12
        gradient.masksToBounds = true
        view.layer.insertSublayer(gradient, at: 0)

        // Keep gradient in sync with cell size
        view.layer.sublayers?.first?.frame = bounds
        layer.needsDisplayOnBoundsChange = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleOverlay.layer.sublayers?.first?.frame = titleOverlay.bounds
    }
}

