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
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1000)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 1000)
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
            
            let mainHomeVC = UINavigationController(rootViewController: MainHomeViewController())
            mainHomeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "newspaper.fill"), tag: 0)
            mainHomeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            
            let viewController = UINavigationController(rootViewController: ViewController())
            viewController.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.fill"), tag: 1)
            viewController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            
            viewControllers = [mainHomeVC, viewController]
        }
    }
}
