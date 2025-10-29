//
//  NetworkService.swift
//  NEWSAPI_SProject
//
//  Created by Willy Hsu on 2025/10/29.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

struct Request {
    let path: String
    var method: HTTPMethod = .GET
    var query: [String: String] = [:]
    var headers: [String: String] = [:]
    var body: Encodable? = nil
}

final class NetworkService {
    private let baseURL = URL(string: "https://newsapi.org")!
    private let session: URLSession
    private let apiKey: String

    init(session: URLSession = .shared) {
        self.session = session
        self.apiKey = (Bundle.main.object(forInfoDictionaryKey: "NEWS_API_KEY") as? String) ?? ""
        precondition(!apiKey.isEmpty, "NEWS_API_KEY is not configured in Info.plist")
    }

    func request<T: Decodable>(_ req: Request, decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        var components = URLComponents(url: baseURL.appendingPathComponent(req.path), resolvingAgainstBaseURL: false)!
        if !req.query.isEmpty {
            components.queryItems = req.query.map { URLQueryItem(name: $0.key, value: $0.value) }
        }

        var urlRequest = URLRequest(url: components.url!)
        urlRequest.httpMethod = req.method.rawValue

        var headers = req.headers
        headers["Accept"] = headers["Accept"] ?? "application/json"
        headers["X-Api-Key"] = headers["X-Api-Key"] ?? apiKey
        headers.forEach { urlRequest.addValue($0.value, forHTTPHeaderField: $0.key) }

        if let body = req.body {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try? JSONEncoder().encode(AnyEncodable(body))
        }

        return session.dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

// MARK: - Service Function
    func get<T: Decodable>(path: String, query: [String: String] = [:], decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        request(Request(path: path, method: .GET, query: query), decoder: decoder)
    }

    func post<T: Decodable, B: Encodable>(path: String, body: B, query: [String: String] = [:], decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        var r = Request(path: path, method: .POST, query: query)
        r.body = body
        return request(r, decoder: decoder)
    }

    func put<T: Decodable, B: Encodable>(path: String, body: B, query: [String: String] = [:], decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        var r = Request(path: path, method: .PUT, query: query)
        r.body = body
        return request(r, decoder: decoder)
    }

    func delete<T: Decodable>(path: String, query: [String: String] = [:], decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        request(Request(path: path, method: .DELETE, query: query), decoder: decoder)
    }
}

private struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void
    init(_ wrapped: Encodable) { self.encodeFunc = wrapped.encode }
    func encode(to encoder: Encoder) throws { try encodeFunc(encoder) }
}

