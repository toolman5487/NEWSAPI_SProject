//
//  BaseListCollectionView.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/11/1.
//

import Foundation
import UIKit
import SnapKit
import Combine

// MARK: - Dynamic Height Protocol
protocol DynamicHeightCollectionViewCell: UICollectionViewCell {
    func calculateSize(for width: CGFloat) -> CGSize
}

class BaseListCollectionView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = true
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
