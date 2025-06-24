//
//  Toast+UIApplicationExtension.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 24/06/25.
//

import UIKit

extension UIApplication {

    func topViewController(
        _ base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        } else if let tab = base as? UITabBarController {
            return topViewController(tab.selectedViewController)
        } else if let presented = base?.presentedViewController {
            return topViewController(presented)
        } else {
            return base
        }
    }
}

