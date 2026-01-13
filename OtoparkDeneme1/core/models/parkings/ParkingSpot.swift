//
//  ParkingSpot.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 1.12.2025.
//

import Foundation

enum ParkingSpotType: String, Decodable {
    case standard = "STANDARD"
    case evCharging = "EV_CHARGING"
    case handicapped = "HANDICAPPED"
}

struct ParkingSpot: Identifiable, Decodable {
    let id: UUID
    let spotCode: String      // Örn: "A-2"
    let occupied: Bool
    let parkingLotId: String
    let type: ParkingSpotType
    let hasCharger: Bool
    
    
    // "A-2" -> "A"
    var lane: String {
        spotCode.split(separator: "-").first.map(String.init) ?? ""
    }
    
    // "A-2" -> 2
    var indexInLane: Int {
        guard let last = spotCode.split(separator: "-").last,
              let n = Int(last) else { return 0 }
        return n
    }
}
