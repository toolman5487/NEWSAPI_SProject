//
//  NewsSearchCell.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/11/1.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage

class NewsSearchCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NewsSearchCell"
    
    private let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.layer.cornerRadius = 8
        image.backgroundColor = .systemGray5
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 4
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(sourceLabel)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        sourceLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(4)
        }
    }
    
    func configure(with article: Article) {
        titleLabel.text = article.title
        descriptionLabel.text = article.description
        sourceLabel.text = article.source.name
        
        if let imageURL = article.urlToImage, let url = URL(string: imageURL) {
            thumbnailImageView.sd_setImage(with: url)
        } else {
            thumbnailImageView.image = nil
        }
    }
}
