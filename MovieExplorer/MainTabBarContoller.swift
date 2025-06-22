//
//  MainTabBarContoller.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 22/06/25.
//

import UIKit

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
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)

        appearance.shadowImage = nil
        appearance.shadowColor = nil

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}


