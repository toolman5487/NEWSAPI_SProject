//
//  NewsDetailViewController.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/10/29.
//

import Foundation
import UIKit
import SnapKit
import Combine

class NewsDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "News Detail"
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
