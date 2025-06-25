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
    private let yearLabel = UILabel()
    private let heartImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.isUserInteractionEnabled = false
        contentView.addSubview(overlayView)
        applyGradient(to: overlayView)
        overlayView.layer.insertSublayer(gradientLayer, at: 0)

        titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(titleLabel)

        yearLabel.font = UIFont.boldSystemFont(ofSize: 14)
        yearLabel.textColor = .systemYellow.withAlphaComponent(0.7)
        yearLabel.numberOfLines = 1
        yearLabel.textAlignment = .left
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(yearLabel)

        heartImageView.translatesAutoresizingMaskIntoConstraints = false
        heartImageView.contentMode = .scaleAspectFit
        heartImageView.image = UIImage(systemName: "heart.fill")
        heartImageView.tintColor = .systemRed
        contentView.addSubview(heartImageView)
        heartImageView.isHidden = true

        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            overlayView.topAnchor.constraint(equalTo: contentView.topAnchor),
            overlayView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            overlayView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            overlayView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            yearLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            yearLabel.topAnchor.constraint(equalTo: overlayView.topAnchor, constant: 4),

            titleLabel.leadingAnchor.constraint(equalTo: overlayView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -4),

            heartImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            heartImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            heartImageView.widthAnchor.constraint(equalToConstant: 24),
            heartImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        overlayView.layer.sublayers?.first?.frame = overlayView.bounds
    }

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

    // MARK: - Public Configuration Methods

    func configure(with movie: Movie, isFavourite: Bool = false) {
        titleLabel.text = movie.title ?? "No Title"
        yearLabel.text = formattedYear(from: movie.releaseDate)

        if let path = movie.posterPath,
           let url = MEUtility.getImageURL(path: path) {
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }

        heartImageView.isHidden = !isFavourite
    }

    func configure(with movie: CDMovie) {
        titleLabel.text = movie.title ?? "No Title"
        yearLabel.text = formattedYear(from: movie.releaseDate)

        if let data = movie.posterImageData {
            imageView.image = UIImage(data: data)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }

        heartImageView.isHidden = false
    }

    // MARK: - Helpers

    private func formattedYear(from dateString: String?) -> String {
        guard let date = dateString, !date.isEmpty else { return "" }
        return String(date.prefix(4))
    }
}
