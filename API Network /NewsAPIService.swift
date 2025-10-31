//
//  NewsAPIService.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/10/30.
//

import Foundation
import Combine

protocol NewsAPIServicing {
    func fetchTopHeadlines(country: String?, category: String?, pageSize: Int) -> AnyPublisher<ArticlesResponse, Error>
    func searchEverything(query: String, sortBy: String?, language: String?, pageSize: Int) -> AnyPublisher<ArticlesResponse, Error>
    func fetchSources(category: String?, language: String?, country: String?) -> AnyPublisher<SourcesResponse, Error>
}

class NewsAPIService: NewsAPIServicing {
    
    private let networkService = NetworkService()
    
    // MARK: - Top Headlines
    func fetchTopHeadlines(country: String? = nil, category: String? = nil, pageSize: Int = 20) -> AnyPublisher<ArticlesResponse, Error> {
        var query: [String: String] = [:]
        if let country = country {
            query["country"] = country
        }
        if let category = category {
            query["category"] = category
        }
        query["pageSize"] = String(pageSize)
        return networkService.get(path: "/v2/top-headlines", query: query)
    }
    
    // MARK: - Everything Search
    func searchEverything(query: String, sortBy: String? = nil, language: String? = nil, pageSize: Int = 20) -> AnyPublisher<ArticlesResponse, Error> {
        var params: [String: String] = [
            "q": query,
            "pageSize": String(pageSize)
        ]
        if let sortBy = sortBy {
            params["sortBy"] = sortBy
        }
        if let language = language {
            params["language"] = language
        }
        return networkService.get(path: "/v2/everything", query: params)
    }
    
    // MARK: - Sources
    func fetchSources(category: String? = nil, language: String? = nil, country: String? = nil) -> AnyPublisher<SourcesResponse, Error> {
        var query: [String: String] = [:]
        if let category = category {
            query["category"] = category
        }
        if let language = language {
            query["language"] = language
        }
        if let country = country {
            query["country"] = country
        }
        return networkService.get(path: "/v2/sources", query: query)
    }
}

