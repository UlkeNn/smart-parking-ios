//
//  KeychainStorage.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 22.11.2025.
//

import Foundation
import Security

enum KeychainStorage {

    private static let tokenKey = "authToken"
    private static let emailKey = "authEmail"

    // MARK: - Save
    static func save(token: String, email: String) {
        saveString(key: tokenKey, value: token)
        saveString(key: emailKey, value: email)
    }

    // MARK: - Load
    static func load() -> (token: String, email: String)? {
        guard let token = loadString(key: tokenKey),
              let email = loadString(key: emailKey) else {
            return nil
        }
        return (token, email)
    }

    // MARK: - Delete
    static func clear() {
        delete(key: tokenKey)
        delete(key: emailKey)
    }

    // MARK: - Low-level Keychain Helpers

    private static func saveString(key: String, value: String) {
        if let data = value.data(using: .utf8) {
            // Önce varsa sil
            delete(key: key)

            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: data
            ]

            SecItemAdd(query as CFDictionary, nil)
        }
    }

    private static func loadString(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            return nil
        }

        return string
    }

    private static func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
