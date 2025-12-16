//
//  DefaultParkingSpotRepository.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 1.12.2025.
//

import Foundation

final class DefaultParkingSpotRepository: ParkingSpotRepository {
    
    private let config: APIConfig
    private let client: APIClient
    
    init(config: APIConfig, client: APIClient) {
        self.config = config
        self.client = client
    }
    convenience init() {
        self.init(
            config: .development,
            client: URLSessionAPIClient()
        )
    }
    private let decoder = JSONDecoder()
    
    func fetchSpots(parkingLotId: String, token: String?) async throws -> [ParkingSpot] {
        // 1) Doğru path: /api/parkingspots/lot/{lotId}
        let base = config.baseURL
            .appendingPathComponent("/api/parkingspots/lot")
            .appendingPathComponent(parkingLotId)
        
        var req = URLRequest(url: base)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        if let token {
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let (data, response) = try await client.send(req)
        guard let http = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        print("📡 GET /api/parkingspots/lot status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")
        
        guard (200..<300).contains(http.statusCode) else {
            throw NSError(
                domain: "ParkingSpotRepo",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"]
            )
        }
        
        return try decoder.decode([ParkingSpot].self, from: data)
    }
}
