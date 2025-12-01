//
//  User.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 29.10.2025.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Role Enum (Backend Role ile aynı)
enum Role: String, Codable {
    case basic
    case admin
    case supervisor
}

// MARK: - User Model (App içi domain model)
struct User: Identifiable, Codable {
    var id: UUID = UUID()
    var fullName: String
    var avatarImageName: String?
    var district: String
    var province: String
    var role: Role

    init(
        id: UUID = UUID(),
        fullName: String,
        avatarImageName: String? = nil,
        district: String,
        province: String,
        role: Role
    ) {
        self.id = id
        self.fullName = fullName
        self.avatarImageName = avatarImageName
        self.district = district
        self.province = province
        self.role = role
    }
}
extension User {
    init(from dto: BackendUserDTO) {
        self.fullName = dto.fullName
        self.avatarImageName = dto.avatarImageName ?? "profilFoto"
        self.role = .basic
        self.district = dto.district
        self.province = dto.province
    }
}
