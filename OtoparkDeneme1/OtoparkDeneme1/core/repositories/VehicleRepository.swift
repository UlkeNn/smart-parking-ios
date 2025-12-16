//
//  VehiclesAPI.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 13.12.2025.
//

import Foundation
protocol VehicleRepository {
    func fetchMyVehicles(token: String?) async throws -> [Vehicle]
    func deleteVehicle(id: String, token: String?) async throws
    func createVehicle(_ request: CreateVehicleRequest, token: String?) async throws -> Vehicle

}
