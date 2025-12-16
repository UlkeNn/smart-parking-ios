//
//  Auth.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 19.11.2025.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

/// /api/auth/login cevabı
struct LoginResponse: Codable {
    let token: String
    // Backend başka alan döndürüyorsa (ör: expiresIn) buraya eklersin:
    // let expiresIn: Int?
}


/// /api/auth/register için gövde
struct RegisterRequest: Codable {
    let email: String
    let password: String
    let fullName: String
    let avatarImageName: String?
    let district: String
    let province: String
}

struct AuthResponse: Codable {
    let token: String   // backend’deki isim neyse (token / accessToken vs.)
    // varsa expiresIn vs. ekleriz
}
