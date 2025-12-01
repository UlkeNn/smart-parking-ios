//
//  ParkingRepository.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 31.10.2025.
//
import Foundation
protocol ParkingRepository {
    func fetchParkings(token: String?) async throws -> [Parking]
}
