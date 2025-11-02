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
    private var searchTask: DispatchWorkItem?
    
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
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                print("Search Error: \(errorMessage)")
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UISearchResultsUpdating
extension NewsSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        // Cancel previous search task
        searchTask?.cancel()
        
        if searchText.isEmpty {
            viewModel.clearResults()
            return
        }
        
        // Debounce: Wait 0.5 seconds before searching
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.searchQuery = searchText
            self?.viewModel.search()
        }
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.item]
        let detailVC = NewsDetailViewController()
        detailVC.configure(with: article)
        if let nav = presentingViewController?.navigationController {
            nav.pushViewController(detailVC, animated: true)
        } else {
            present(detailVC, animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewsSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 32, height: 120)
    }
}

