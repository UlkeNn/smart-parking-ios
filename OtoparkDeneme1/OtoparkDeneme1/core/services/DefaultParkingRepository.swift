//
//  DefaultParkingRepository.swift
//  OtoparkDeneme1
// 
//  Created by Ulgen on 31.10.2025.
//
import Foundation

final class DefaultParkingRepository: ParkingRepository {

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

    // Eğer endpoint token istiyorsa, token'ı dışarıdan alacağız
    func fetchParkings(token: String?) async throws -> [Parking] {
        let url = config.baseURL.appendingPathComponent("/api/parking-lots")
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

        let backendLots = try decoder.decode([BackendParkingLotDTO].self, from: data)
        return backendLots.map(Parking.init(from:))
    }
}
