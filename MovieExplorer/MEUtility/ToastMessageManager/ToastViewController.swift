//
//  ToastViewController.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 23/06/25.
//

import UIKit

final class ToastViewController: UIViewController {

    private let message: String
    private let duration: TimeInterval = 0.8

    private let toastLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black.withAlphaComponent(0.7)
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()


    init(message: String) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        view.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToast()
        showToastAndDismiss()
    }

    private func setupToast() {
        view.addSubview(toastLabel)
        toastLabel.text = message

        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            toastLabel.widthAnchor.constraint(equalToConstant: 280),
            toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }

    private func showToastAndDismiss() {
        toastLabel.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.toastLabel.alpha = 1
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.duration) {
                UIView.animate(withDuration: 0.3, animations: {
                    self.toastLabel.alpha = 0
                }) { _ in
                    self.dismiss(animated: false)
                }
            }
        }
    }
}
