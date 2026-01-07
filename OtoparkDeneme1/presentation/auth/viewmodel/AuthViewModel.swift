//
//  AuthViewModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 19.11.2025.
//

import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    @Published var avatarImageName = "profilFoto"
    @Published var district = ""
    @Published var province = ""

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: AuthRepository

    // 🔴 ÖNEMLİ KISIM: BURASI
    init(repository: AuthRepository = DefaultAuthRepository()) {
        self.repository = repository
    }

    // geri kalan login / register aynen:
    func login() async -> (token: String, user: BackendUserDTO)? {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let req = LoginRequest(email: email, password: password)
            let result = try await repository.login(req)
            return result
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Giriş başarısız."
            return nil
        }
    }

    func register() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        let req = RegisterRequest(
            email: email,
            password: password,
            fullName: fullName,
            avatarImageName: avatarImageName,
            district: district,
            province: province
        )

        do {
            try await repository.register(req)
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "Kayıt işlemi başarısız."
        }
    }
}
