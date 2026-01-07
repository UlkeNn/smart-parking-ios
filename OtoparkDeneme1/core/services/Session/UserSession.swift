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

    // Aktif araç
    @Published var selectedVehicleId: String?

    // Kullanıcının giriş yapıp yapmadığını anlamanın tek yolu
    var isLoggedIn: Bool { token != nil }

    // MARK: - Init
    init(
        user: User,
        token: String? = nil,
        selectedVehicleId: String? = nil
    ) {
        self.user = user
        self.token = token
        self.selectedVehicleId = selectedVehicleId
    }

    // MARK: - Login uygula
    func applyLogin(user: User, token: String) {
        self.user = user
        self.token = token
    }

    // MARK: - Logout
    func applyLogout() {
        token = nil
        KeychainStorage.clear()
        clearSelectedVehicle()   

        self.user = User(
            fullName: "",
            avatarImageName: "profilFoto",
            district: "",
            province: "",
            role: .basic
        )
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
            applyLogout()
        }
    }
}

// VEHICLE
extension UserSession {

    private static let selectedVehicleKey = "selectedVehicleId"

    func persistSelectedVehicle() {
        UserDefaults.standard.set(selectedVehicleId, forKey: Self.selectedVehicleKey)
    }

    static func loadSelectedVehicleId() -> String? {
        UserDefaults.standard.string(forKey: selectedVehicleKey)
    }

    func clearSelectedVehicle() {
        selectedVehicleId = nil
        UserDefaults.standard.removeObject(forKey: Self.selectedVehicleKey)
    }
}

// MARK: - İlk açılış load
extension UserSession {
    static func initial() -> UserSession {
        let storedToken = KeychainStorage.load()?.token
        let storedVehicleId = UserSession.loadSelectedVehicleId()

        let emptyUser = User(
            fullName: "",
            avatarImageName: "profilFoto",
            district: "",
            province: "",
            role: .basic
        )

        return UserSession(
            user: emptyUser,
            token: storedToken,
            selectedVehicleId: storedVehicleId
        )
    }
}



// MARK: - Token Shortcut
extension UserSession {
    static var sharedToken: String? {
        KeychainStorage.load()?.token
    }
}
