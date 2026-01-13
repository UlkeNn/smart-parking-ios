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

    //seçilen otopark + zaman aralığı için dolu (çakışan) rezervasyonları getirir
    func fetchUnavailableReservations(
        parkingLotId: String,
        startDate: Date,
        endDate: Date
    ) async throws -> [Reservation]
    //id ile rezervasyon silmek
    func cancelReservation(id: UUID) async throws
}

