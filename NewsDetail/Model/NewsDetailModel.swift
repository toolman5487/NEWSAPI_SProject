//
//  NewsDetailModel.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/10/29.
//

import Foundation


struct ArticlesResponse: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Decodable {
    struct Source: Decodable {
        let id: String?
        let name: String
    }

    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

