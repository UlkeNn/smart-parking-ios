//
//  BackendParkingLotDTO.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 25.11.2025.
//

import Foundation

struct BackendParkingLotDTO: Codable, Identifiable {
    let id: UUID
    let code: String
    let name: String
    let district: String
    let province: String
    let address: String?
    let latitude: Double
    let longitude: Double
    let hourlyRate: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case name
        case district
        case province
        case address
        case latitude
        case longitude
        case hourlyRate = "hourly_rate"   // snake_case -> camelCase
    }
}
