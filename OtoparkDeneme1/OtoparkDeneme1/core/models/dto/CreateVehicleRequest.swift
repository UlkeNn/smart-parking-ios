//
//  CreateVehicleRequest.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 13.12.2025.
//

import Foundation

struct CreateVehicleRequest: Codable {
    let plateNumber: String
    let type: VehicleType
}
