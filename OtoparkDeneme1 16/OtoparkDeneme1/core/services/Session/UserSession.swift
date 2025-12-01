//
//  UserSession.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 29.10.2025.
//

import Foundation
import SwiftUI
import Combine

final class UserSession: ObservableObject {

    // MARK: - Published Properties
    @Published var user: User
    @Published var token: String?

    // Kullanıcının giriş yapıp yapmadığını anlamanın tek yolu
    var isLoggedIn: Bool { token != nil }

    // MARK: - Init
    init(user: User, token: String? = nil) {
        self.user = user
        self.token = token
    }

    // MARK: - Login uygula
    func applyLogin(user: User, token: String) {
        self.user = user
        self.token = token
    }

    // MARK: - Logout
    func logout() {
        token = nil
        KeychainStorage.clear()

        self.user = User(
            fullName: "",
            avatarImageName: "profilFoto",
            district: "",
            province: "",
            role: .basic
        )
    }

    // MARK: - Mock (Preview & Debug için)
    static func mock() -> UserSession {
        let mockUser = User(
            fullName: "Misafir Kullanıcı",
            avatarImageName: "profilFoto",
            district: "",
            province: "",
            role: .basic
        )

        // token nil → login ekranı açılır
        return .init(user: mockUser, token: nil)
    }

    // MARK: - App açılırken kullanıcı bilgilerini backend'den yükle
    func restoreUserFromBackend() async {
        guard let token = token else { return }

        do {
            // DefaultAuthRepository() artık çalışıyor (convenience init sayesinde)
            let repo = DefaultAuthRepository()
            let backendUser = try await repo.fetchMe(token: token)

            let user = User(
                fullName: backendUser.fullName,
                avatarImageName: backendUser.avatarImageName ?? "profilFoto",
                district: backendUser.district,
                province: backendUser.province,
                role: .basic
            )

            applyLogin(user: user, token: token)
        } catch {
            print("❌ restoreUserFromBackend: \(error)")
            logout()
        }
    }
}


// MARK: - İlk açılış load
extension UserSession {
    static func initial() -> UserSession {
        if let stored = KeychainStorage.load() {
            let emptyUser = User(
                fullName: "",
                avatarImageName: "profilFoto",
                district: "",
                province: "",
                role: .basic
            )

            return UserSession(user: emptyUser, token: stored.token)
        }

        return UserSession(
            user: User(
                fullName: "",
                avatarImageName: "profilFoto",
                district: "",
                province: "",
                role: .basic
            ),
            token: nil
        )
    }
}


// MARK: - Token Shortcut
extension UserSession {
    static var sharedToken: String? {
        KeychainStorage.load()?.token
    }
}
