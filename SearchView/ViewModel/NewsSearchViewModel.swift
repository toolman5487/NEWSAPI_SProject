//
//  NewsSearchViewModel.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/10/31.
//

import Foundation
import Combine

class NewsSearchViewModel {
    // MARK: - Dependencies
    private let service: NewsAPIServicing
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Input
    @Published var searchQuery: String = ""
    
    // MARK: - Output
    @Published var articles: [Article] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Initialization
    init(service: NewsAPIServicing = NewsAPIService()) {
        self.service = service
    }
    
    // MARK: - Actions
    func search() {
        guard !searchQuery.trimmingCharacters(in: .whitespaces).isEmpty else {
            clearResults()
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        service.searchEverything(query: searchQuery, sortBy: nil, language: nil, pageSize: 20)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.articles = response.articles
                }
            )
            .store(in: &cancellables)
    }
    
    func clearResults() {
        articles = []
        errorMessage = nil
    }
}

