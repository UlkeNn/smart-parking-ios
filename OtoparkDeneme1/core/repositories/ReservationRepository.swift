//
//  ReservationRepository.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 26.11.2025.
//

import Foundation

protocol ReservationRepository {
    func fetchMyReservations() async throws -> [Reservation]
    func createReservation(_ request: CreateReservationRequest) async throws -> Reservation
    // İstersen -> Void yapabilirsin, ama Reservation döndürmek ileride işine yarar
}

