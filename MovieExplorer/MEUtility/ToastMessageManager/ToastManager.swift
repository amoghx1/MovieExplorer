//
//  ToastManager.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 24/06/25.
//

import UIKit

enum ToastManager {

    static func show(message: String, in context: UIViewController? = nil) {
        guard let rootVC = context ?? UIApplication.shared.topViewController() else {
            print("ToastManager: No top view controller found")
            return
        }

        let toastVC = ToastViewController(message: message)
        rootVC.present(toastVC, animated: false)
    }
}
