//
//  NewsDetailCell.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/11/1.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import Combine

// MARK: - Title Cell
class NewsDetailTitleCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NewsDetailTitleCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .label
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
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with title: String) {
        titleLabel.text = title
    }
}

// MARK: - Image Cell
class NewsDetailImageCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NewsDetailImageCell"
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray6
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(240)
        }
    }
    
    func configure(with imageURL: String?) {
        if let urlString = imageURL, let url = URL(string: urlString) {
            imageView.sd_setImage(with: url)
        } else {
            imageView.image = UIImage(systemName: "photo.badge.arrow.down")
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .secondaryLabel
        }
    }
}

// MARK: - Metadata Cell
class NewsDetailMetadataCell: UICollectionViewCell {
    
    static let reuseIdentifier = "NewsDetailMetadataCell"
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [sourceLabel, authorLabel, dateLabel])
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 12
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(source: String, author: String?, date: String) {
        sourceLabel.text = source
        authorLabel.text = author
        dateLabel.text = date
    }
}

// MARK: - Content Cell
class NewsDetailContentCell: UICollectionViewCell, DynamicHeightCollectionViewCell {
    
    static let reuseIdentifier = "NewsDetailContentCell"
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .label
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
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    func configure(with content: String?) {
        contentLabel.text = content ?? nil
    }
    
    func calculateSize(for width: CGFloat) -> CGSize {
        // Use current configured cell to calculate size
        let savedFrame = frame
        frame = CGRect(x: 0, y: 0, width: width, height: UIView.layoutFittingCompressedSize.height)
        layoutIfNeeded()
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        let size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        frame = savedFrame // Restore frame
        return CGSize(width: width, height: size.height)
    }
}

// MARK: - Read More Cell
class NewsDetailReadMoreCell: UICollectionViewCell {
    
    let tapPublisher = PassthroughSubject<Void, Never>()
    static let reuseIdentifier = "NewsDetailReadMoreCell"
    
    private let button: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Read More", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(12)
            make.height.equalTo(40)
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        tapPublisher.send(())
    }
}
