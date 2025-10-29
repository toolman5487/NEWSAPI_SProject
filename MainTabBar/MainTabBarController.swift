//
//  MainTabBarController.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/10/28.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = .label
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterialLight)
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        let mainHomeVC = UINavigationController(rootViewController: MainHomeViewController())
        mainHomeVC.tabBarItem = UITabBarItem(title: "首頁", image: UIImage(systemName: "newspaper.fill"), tag: 0)

        let viewController = UINavigationController(rootViewController: ViewController())
        viewController.tabBarItem = UITabBarItem(title: "頁面", image: UIImage(systemName: "person.fill"), tag: 1)

        viewControllers = [mainHomeVC, viewController]
    }
}
