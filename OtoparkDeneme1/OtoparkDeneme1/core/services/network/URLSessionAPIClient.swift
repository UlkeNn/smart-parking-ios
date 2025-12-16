//
//  URLSessionAPIClient.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 30.11.2025.
//
import Foundation

final class URLSessionAPIClient: APIClient {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        return (data, http)
    }
}
