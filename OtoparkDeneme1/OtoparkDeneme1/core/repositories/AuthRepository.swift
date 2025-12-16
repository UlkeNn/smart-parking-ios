//
//  AuthRepository.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 19.11.2025.
//

import Foundation

protocol AuthRepository {
    func register(_ request: RegisterRequest) async throws
    func login(_ request: LoginRequest) async throws -> (token: String, user: BackendUserDTO)
    func logout(token: String) async throws
}
