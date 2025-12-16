//
//  Parking.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 31.10.2025.
//

import Foundation
import CoreLocation

struct ParkingMapModel: Codable, Identifiable, Hashable {
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
