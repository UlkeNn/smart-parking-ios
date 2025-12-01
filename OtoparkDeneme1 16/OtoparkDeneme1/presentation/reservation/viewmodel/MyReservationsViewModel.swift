//
//  MyReservationsViewModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 26.11.2025.
//

import Foundation
import Combine

@MainActor
final class MyReservationsViewModel: ObservableObject {
    @Published var reservations: [Reservation] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repo: ReservationRepository

    init(repo: ReservationRepository = DefaultReservationRepository()) {
        self.repo = repo
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            reservations = try await repo.fetchMyReservations()
        } catch {
            errorMessage = "Rezervasyonlar alınırken hata oluştu: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
