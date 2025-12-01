//
//  DefaultAuthRepository.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 19.11.2025.
//

import Foundation

final class DefaultAuthRepository: AuthRepository {

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

    private let jsonDecoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    private let jsonEncoder: JSONEncoder = {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .useDefaultKeys
        return e
    }()

   

    func register(_ request: RegisterRequest) async throws {
        let url = config.baseURL.appendingPathComponent("/api/auth/register")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try jsonEncoder.encode(request)

        let (_, response) = try await client.send(urlRequest)
        guard (200..<300).contains(response.statusCode) else {
            throw AuthError.registerFailed
        }
    }

    func login(_ request: LoginRequest) async throws -> (token: String, user: BackendUserDTO) {

        // 1) Login
        let loginURL = config.baseURL.appendingPathComponent("/api/auth/login")
        var loginReq = URLRequest(url: loginURL)
        loginReq.httpMethod = "POST"
        loginReq.addValue("application/json", forHTTPHeaderField: "Content-Type")
        loginReq.httpBody = try jsonEncoder.encode(request)

        let (loginData, loginHTTP) = try await client.send(loginReq)
        guard (200..<300).contains(loginHTTP.statusCode) else {
            throw AuthError.invalidCredentials
        }

        let login = try jsonDecoder.decode(LoginResponse.self, from: loginData)
        let token = login.token

        // 2) /me
        let meURL = config.baseURL.appendingPathComponent("/api/users/me")
        var meReq = URLRequest(url: meURL)
        meReq.httpMethod = "GET"
        meReq.addValue("application/json", forHTTPHeaderField: "Accept")
        meReq.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (meData, meHTTP) = try await client.send(meReq)
        guard (200..<300).contains(meHTTP.statusCode) else {
            throw AuthError.fetchUserFailed
        }

        let backendUser = try jsonDecoder.decode(BackendUserDTO.self, from: meData)
        return (token: token, user: backendUser)
    }
}

extension DefaultAuthRepository {
    func fetchMe(token: String) async throws -> BackendUserDTO {
        let url = config.baseURL.appendingPathComponent("/api/users/me")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"
        req.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (data, http) = try await client.send(req)
        guard (200..<300).contains(http.statusCode) else {
            throw AuthError.fetchUserFailed
        }

        return try jsonDecoder.decode(BackendUserDTO.self, from: data)
    }
}

// MARK: - Errors

enum AuthError: LocalizedError {
    case invalidCredentials
    case registerFailed
    case fetchUserFailed

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "E-posta veya şifre hatalı."
        case .registerFailed:
            return "Kayıt işlemi başarısız."
        case .fetchUserFailed:
            return "Kullanıcı bilgileri alınamadı."
        }
    }
}
