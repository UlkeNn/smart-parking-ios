//
//  ParkingSpotRepository.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 1.12.2025.
//

import Foundation

protocol ParkingSpotRepository {
    func fetchSpots(parkingLotId: String, token: String?) async throws -> [ParkingSpot]
}

