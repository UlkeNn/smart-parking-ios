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

    // Backend tarih: 2025-11-26T22:28:07.560544
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

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()

        d.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)

            if let date = DefaultReservationRepository
                .dateFormatterWithFraction
                .date(from: str) {
                return date
            }

            if let date = DefaultReservationRepository
                .dateFormatterNoFraction
                .date(from: str) {
                return date
            }

            throw DecodingError.dataCorrupted(
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Geçersiz tarih formatı: \(str)"
                )
            )
        }

        return d
    }()

    // Asıl init
    init(config: APIConfig, client: APIClient) {
        self.config = config
        self.client = client
    }

    // Kolay kullanım (DefaultReservationRepository() için)
    convenience init() {
        self.init(
            config: .development,
            client: URLSessionAPIClient()
        )
    }

    // MARK: - Helper: Authorization header ekle
    private func addAuthHeader(to request: inout URLRequest) {
        if let token = UserSession.sharedToken {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("⚠️ Reservation isteğinde token bulunamadı")
        }
    }

    // MARK: - GET /api/reservations/my
    func fetchMyReservations() async throws -> [Reservation] {
        let url = config.baseURL.appendingPathComponent("/api/reservations/my")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addValue("application/json", forHTTPHeaderField: "Accept")

        addAuthHeader(to: &req)

        let (data, http) = try await client.send(req)

        print("📡 /api/reservations/my status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw NSError(
                domain: "ReservationsAPI",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode) hatası"]
            )
        }

        return try decoder.decode([Reservation].self, from: data)
    }

    // MARK: - POST /api/reservations
    func createReservation(_ request: CreateReservationRequest) async throws -> Reservation {
        let url = config.baseURL.appendingPathComponent("/api/reservations")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.addValue("application/json", forHTTPHeaderField: "Accept")

        addAuthHeader(to: &req)

        // 🟦 1) Encode + LOG
        let bodyData = try JSONEncoder().encode(request)
        req.httpBody = bodyData

        if let jsonString = String(data: bodyData, encoding: .utf8) {
            print("📤 POST /api/reservations BODY JSON:")
            print(jsonString)
        }
        //istek göndermece
        let (data, http) = try await client.send(req)

        print("📡 POST /api/reservations status:", http.statusCode)
        print("📦 body:", String(data: data, encoding: .utf8) ?? "-")

        guard (200..<300).contains(http.statusCode) else {
            throw NSError(
                domain: "ReservationsAPI",
                code: http.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "Rezervasyon oluşturma hatası (HTTP \(http.statusCode))"]
            )
        }

        // Dönüşü kullanmak istemezsen:
        // _ = try? decoder.decode(Reservation.self, from: data)
        // ve fonksiyonun dönüş tipini -> Void yapabilirsin.
        return try decoder.decode(Reservation.self, from: data)
    }
}
