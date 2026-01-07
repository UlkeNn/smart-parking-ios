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
    private let decoder: JSONDecoder = JSONDecoder()

    // Asıl init (DI için)
    init(config: APIConfig, client: APIClient) {
        self.config = config
        self.client = client
    }

    // Kolay kullanım (Auth’ta yaptığımız gibi)
    convenience init() {
        self.init(
            config: .development,
            client: URLSessionAPIClient()
        )
    }

    // GET /api/vehicles/my
    func fetchMyVehicles(token: String?) async throws -> [Vehicle] {

        // 🔴 APIConfig baseURL dışında tam URL
        let url = URL(string: "http://31.57.187.120:8080/api/vehicles/my")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        if let token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, http) = try await client.send(request)

        guard (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode([Vehicle].self, from: data)
    }
    func deleteVehicle(id: String, token: String?) async throws {
            let url = config.baseURL.appendingPathComponent("/api/vehicles/\(id)")

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            if let token { request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }

            let (_, http) = try await client.send(request)
            guard (200..<300).contains(http.statusCode) else { throw URLError(.badServerResponse) }
        }
    func createVehicle(_ requestBody: CreateVehicleRequest, token: String?) async throws -> Vehicle {
        let url = config.baseURL.appendingPathComponent("/api/vehicles")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token { request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization") }

        request.httpBody = try JSONEncoder().encode(requestBody)

        let (data, http) = try await client.send(request)
        guard (200..<300).contains(http.statusCode) else { throw URLError(.badServerResponse) }

        return try decoder.decode(Vehicle.self, from: data)
    }

}
