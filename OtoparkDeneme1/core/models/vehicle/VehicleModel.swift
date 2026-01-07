//
//  VehicleModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 13.12.2025.
//

import Foundation

enum VehicleType: String, Codable {
    case standard = "STANDARD"
    case ev = "EV"
    case motorcycle = "MOTORCYCLE"

    var displayName: String {
        switch self {
        case .standard: return "Standart"
        case .ev: return "Elektrikli"
        case .motorcycle: return "Motorsiklet"
        }
    }
}

struct Vehicle: Identifiable, Codable, Hashable {
    let id: String
    let plateNumber: String
    let ownerId: String?
    let ownerEmail: String?
    let ownerFullName: String?
    let type: VehicleType
}
