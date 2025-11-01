//
//  MainHomeViewController.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/10/28.
//

import Foundation
import UIKit
import SnapKit
import Combine

class MainHomeViewController: UIViewController {
    
    private let searchResultsController = NewsSearchViewController()
    private lazy var searchController = UISearchController(searchResultsController: searchResultsController)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MainHome"
        setupNavigationAndSearchBar()
    }
    
    private func setupNavigationAndSearchBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search news..."
        searchController.searchResultsUpdater = searchResultsController
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}
