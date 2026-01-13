//
//  DefaultVehiclesAPI.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 13.12.2025.
//

import Foundation

final class DefaultVehicleRepository: VehicleRepository {

    private let config: APIConfig
    private let client: APIClient
    private let decoder = JSONDecoder()

    init(config: APIConfig = .development, client: APIClient = URLSessionAPIClient()) {
        self.config = config
        self.client = client
    }

    convenience init() {
        self.init(config: .development, client: URLSessionAPIClient())
    }

    // GET /api/vehicles/my
    func fetchMyVehicles(token: String?) async throws -> [Vehicle] {
        let url = config.baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("vehicles")
            .appendingPathComponent("my")

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Accept")

        if let token {
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        print("➡️ REQUEST URL:", req.url?.absoluteString ?? "nil")

        let (data, http) = try await client.send(req)

        print("📡 GET /api/vehicles/my status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode([Vehicle].self, from: data)
    }

    // POST /api/vehicles
    func createVehicle(_ request: CreateVehicleRequest, token: String?) async throws -> Vehicle {
        let url = config.baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("vehicles")

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if let token {
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        req.httpBody = try JSONEncoder().encode(request)

        print("➡️ REQUEST URL:", req.url?.absoluteString ?? "nil")

        let (data, http) = try await client.send(req)

        print("📡 POST /api/vehicles status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(Vehicle.self, from: data)
    }

    // DELETE /api/vehicles/{id}
    func deleteVehicle(id: UUID, token: String?) async throws {
        let url = config.baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("vehicles")
            .appendingPathComponent(id.uuidString)

        var req = URLRequest(url: url)
        req.httpMethod = "DELETE"
        req.addValue("application/json", forHTTPHeaderField: "Accept")

        if let token {
            req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        print("➡️ REQUEST URL:", req.url?.absoluteString ?? "nil")

        let (data, http) = try await client.send(req)

        print("📡 DELETE /api/vehicles/{id} status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw NSError(domain: "VehicleRepo",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode)"])
        }
    }
}
