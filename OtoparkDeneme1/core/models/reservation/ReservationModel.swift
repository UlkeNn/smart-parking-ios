//
//  ReservationModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 26.11.2025.
//

// Models/Reservation.swift

import Foundation

struct Reservation: Identifiable, Decodable, Hashable {
    let id: UUID
    let userId: UUID
    let vehicleId: UUID
    let vehiclePlate: String?
    let parkingSpotId: UUID
    let parkingLotId: UUID
    let parkingLotName: String?
    let parkingSpotCode: String?
    
    let totalPrice: Double
    let currentChargeLevel: Int?
    let reservedStart: Date
    let reservedEnd: Date
    let active: Bool
    let confirmed: Bool
    let qrCode: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case vehicleId
        case vehiclePlate
        case parkingSpotId
        case parkingLotId
        case parkingLotName
        case parkingSpotCode
        case totalPrice
        case currentChargeLevel
        case reservedStart
        case reservedEnd
        case active
        case confirmed
        case qrCode
    }
}
