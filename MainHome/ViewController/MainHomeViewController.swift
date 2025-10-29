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
    
    private let searchController = UISearchController(searchResultsController: nil)
    
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
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UISearchBarDelegate
extension MainHomeViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let vc = NewsSearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
