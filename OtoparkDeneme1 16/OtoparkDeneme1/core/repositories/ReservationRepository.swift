//
//  ReservationRepository.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 26.11.2025.
//

import Foundation

protocol ReservationRepository {
    /// Giriş yapmış kullanıcının rezervasyonlarını döner
    func fetchMyReservations() async throws -> [Reservation]
}
