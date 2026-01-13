//
//  APIConfig.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 30.11.2025.
//
import Foundation

struct APIConfig {
    let baseURL: URL

    // İstersen farklı ortamlar:
    static let development = APIConfig(
        baseURL: URL(string: "http://Your.API.Is.Here:8080")!////!!!!!!!!!!!!!!!!!!!!!!!!!!
    )
}
