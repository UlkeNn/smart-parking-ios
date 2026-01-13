//
//  CreateReservationRequest.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 26.11.2025.
//

import Foundation
struct CreateReservationRequest: Encodable {
    let parkingSpotId: UUID
    let vehicleId: UUID       // UUID DEĞİL → STRING
    let reservedStart: String
    let reservedEnd: String
}

