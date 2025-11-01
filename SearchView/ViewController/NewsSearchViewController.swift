//
//  NewsSearchViewController.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/10/29.
//

import Foundation
import UIKit
import SnapKit
import Combine

class NewsSearchViewController: UIViewController {
    
    private let viewModel = NewsSearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchBar.delegate = self
        sc.searchBar.placeholder = "Search news..."
        sc.obscuresBackgroundDuringPresentation = false
        return sc
    }()
    
    private lazy var collectionView: BaseListCollectionView = {
        let view = BaseListCollectionView(frame: .zero)
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.collectionView.register(NewsSearchCell.self, forCellWithReuseIdentifier: NewsSearchCell.reuseIdentifier)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.$articles
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchBarDelegate
extension NewsSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.searchQuery = text
        viewModel.search()
        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource
extension NewsSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsSearchCell.reuseIdentifier, for: indexPath) as? NewsSearchCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.articles[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension NewsSearchViewController: UICollectionViewDelegate {
    
}
