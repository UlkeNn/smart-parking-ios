//
//  DefaultReservationRepository.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 26.11.2025.
//

// Services/Reservations/DefaultReservationRepository.swift

import Foundation

final class DefaultReservationRepository: ReservationRepository {

    private let config: APIConfig
    private let client: APIClient

    private static let dateFormatterWithFraction: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return f
    }()

    private static let dateFormatterNoFraction: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()

    private static let apiQueryDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        // LocalDateTime -> timezone yok, en güvenlisi cihaz saatini stringlemek
        // istersen f.timeZone = .current de yapabilirsin, default zaten current
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)

            if let date = DefaultReservationRepository.dateFormatterWithFraction.date(from: str) {
                return date
            }
            if let date = DefaultReservationRepository.dateFormatterNoFraction.date(from: str) {
                return date
            }

            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath,
                      debugDescription: "Geçersiz tarih formatı: \(str)")
            )
        }
        return d
    }()

    init(config: APIConfig, client: APIClient) {
        self.config = config
        self.client = client
    }

    convenience init() {
        self.init(config: .development, client: URLSessionAPIClient())
    }

    private func addAuthHeader(to request: inout URLRequest) {
        if let token = UserSession.sharedToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("Reservation isteğinde token bulunamadı")
        }
    }

    // MARK: - GET /api/reservations/my
    func fetchMyReservations() async throws -> [Reservation] {
        let url = config.baseURL.appendingPathComponent("api").appendingPathComponent("reservations").appendingPathComponent("my")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(to: &req)

        print("➡️ REQUEST URL:", req.url?.absoluteString ?? "nil")

        let (data, http) = try await client.send(req)

        print("📡 /api/reservations/my status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw NSError(domain: "ReservationsAPI",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode) hatası"])
        }

        return try decoder.decode([Reservation].self, from: data)
    }

    // MARK: - POST /api/reservations
    func createReservation(_ request: CreateReservationRequest) async throws -> Reservation {
        let url = config.baseURL.appendingPathComponent("api").appendingPathComponent("reservations")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(to: &req)

        let bodyData = try JSONEncoder().encode(request)
        req.httpBody = bodyData

        if let jsonString = String(data: bodyData, encoding: .utf8) {
            print("📤 POST /api/reservations BODY JSON:")
            print(jsonString)
        }

        print("➡️ REQUEST URL:", req.url?.absoluteString ?? "nil")

        let (data, http) = try await client.send(req)

        print("📡 POST /api/reservations status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw NSError(domain: "ReservationsAPI",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Rezervasyon oluşturma hatası (HTTP \(http.statusCode))"])
        }

        return try decoder.decode(Reservation.self, from: data)
    }

    // MARK: - GET /api/reservations/unavailable?parkingLotId=...&startTime=...&endTime=...
    func fetchUnavailableReservations(
        parkingLotId: String,
        startDate: Date,
        endDate: Date
    ) async throws -> [Reservation] {

        var components = URLComponents(url: config.baseURL, resolvingAgainstBaseURL: false)!
        components.path = "/api/reservations/unavailable"

        let f = Self.apiQueryDateFormatter

        components.queryItems = [
            URLQueryItem(name: "parkingLotId", value: parkingLotId),
            URLQueryItem(name: "startTime", value: f.string(from: startDate)),
            URLQueryItem(name: "endTime", value: f.string(from: endDate))
        ]

        guard let url = components.url else { throw URLError(.badURL) }

        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(to: &req)

        print("➡️ REQUEST URL:", req.url?.absoluteString ?? "nil")

        let (data, http) = try await client.send(req)

        print("📡 GET /api/reservations/unavailable status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw NSError(domain: "ReservationsAPI",
                          code: http.statusCode,
                          userInfo: [NSLocalizedDescriptionKey: "Unavailable hatası (HTTP \(http.statusCode))"])
        }

        return try decoder.decode([Reservation].self, from: data)
    }
    
    // MARK: - POST /api/reservations/{id}/cancel
    func cancelReservation(id: UUID) async throws {
        let url = config.baseURL
            .appendingPathComponent("api")
            .appendingPathComponent("reservations")
            .appendingPathComponent(id.uuidString)
            .appendingPathComponent("cancel")

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        addAuthHeader(to: &req)

        print("➡️ CANCEL REQUEST URL:", req.url?.absoluteString ?? "nil")

        let (data, http) = try await client.send(req)

        print("📡 /api/reservations/{id}/cancel status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw NSError(
                domain: "ReservationsAPI",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "İptal hatası (HTTP \(http.statusCode))"]
            )
        }
    }

}
