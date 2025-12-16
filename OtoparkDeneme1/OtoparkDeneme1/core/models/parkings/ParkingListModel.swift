//
//  ParkingListModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 6.11.2025.
//

import Foundation

import CoreLocation

struct Parking: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let capacity: Int?
    let available: Int?
    let address: String?

    var coordinate: CLLocationCoordinate2D {
        .init(latitude: latitude, longitude: longitude)
    }

    var availabilityText: String {
        if let a = available, let c = capacity { return "\(a)/\(c) boş" }
        if let a = available { return "\(a) boş" }
        return "Doluluk bilgisi yok"
    }
}

// MARK: - Backend map

extension Parking {
    init(from dto: BackendParkingLotDTO) {
        self.id = dto.id.uuidString
        self.name = dto.name
        self.latitude = dto.latitude
        self.longitude = dto.longitude
        self.capacity = nil          // Şimdilik yok, ileride status endpoint'inden doldururuz
        self.available = nil
        // district+province istersen address'e göm
        if let addr = dto.address {
            self.address = "\(addr) - \(dto.district)/\(dto.province)"
        } else {
            self.address = "\(dto.district)/\(dto.province)"
        }
    }
}

