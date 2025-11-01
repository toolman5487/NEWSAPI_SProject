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
    
    private var article: Article?
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.dataSource = self
        cv.register(NewsDetailTitleCell.self, forCellWithReuseIdentifier: NewsDetailTitleCell.reuseIdentifier)
        cv.register(NewsDetailImageCell.self, forCellWithReuseIdentifier: NewsDetailImageCell.reuseIdentifier)
        cv.register(NewsDetailMetadataCell.self, forCellWithReuseIdentifier: NewsDetailMetadataCell.reuseIdentifier)
        cv.register(NewsDetailContentCell.self, forCellWithReuseIdentifier: NewsDetailContentCell.reuseIdentifier)
        cv.register(NewsDetailReadMoreCell.self, forCellWithReuseIdentifier: NewsDetailReadMoreCell.reuseIdentifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with article: Article) {
        self.article = article
        collectionView.reloadData()
    }
}

enum NewsDetailSection: Int, CaseIterable {
    case title, image, metadata, content, readMore
}

// MARK: - UICollectionViewDataSource
extension NewsDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewsDetailSection.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let article = article else { return UICollectionViewCell() }
        
        let section = NewsDetailSection(rawValue: indexPath.item)!
        
        switch section {
        case .title:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailTitleCell.reuseIdentifier, for: indexPath) as? NewsDetailTitleCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: article.title)
            return cell
            
        case .image:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailImageCell.reuseIdentifier, for: indexPath) as? NewsDetailImageCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: article.urlToImage)
            return cell
            
        case .metadata:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailMetadataCell.reuseIdentifier, for: indexPath) as? NewsDetailMetadataCell else {
                return UICollectionViewCell()
            }
            cell.configure(source: article.source.name, author: article.author, date: article.publishedAt)
            return cell
            
        case .content:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailContentCell.reuseIdentifier, for: indexPath) as? NewsDetailContentCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: article.description)
            return cell
            
        case .readMore:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsDetailReadMoreCell.reuseIdentifier, for: indexPath) as? NewsDetailReadMoreCell else {
                return UICollectionViewCell()
            }
            let articleURL = article.url
            cell.tapPublisher
                .sink { _ in
                    guard let url = URL(string: articleURL) else { return }
                    UIApplication.shared.open(url)
                }
                .store(in: &cancellables)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NewsDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = NewsDetailSection(rawValue: indexPath.item)!
        let width = collectionView.bounds.width
        
        switch section {
        case .title:
            return CGSize(width: width, height: 120)
        case .image:
            return CGSize(width: width, height: 250)
        case .metadata:
            return CGSize(width: width, height: 60)
        case .content:
            return CGSize(width: width, height: 200)
        case .readMore:
            return CGSize(width: width, height: 80)
        }
    }
}
