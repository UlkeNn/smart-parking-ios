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
    
    @Published var isCancelling = false
    
    private let repo: ReservationRepository
    
    init(repo: ReservationRepository = DefaultReservationRepository()) {
        self.repo = repo
    }
    
    @MainActor
    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let fetched = try await repo.fetchMyReservations()

            //  Gelecek → Geçmiş SIRALAMA
            reservations = fetched.sorted {
                $0.reservedStart > $1.reservedStart
            }

        } catch is CancellationError {
            return
        } catch let urlError as URLError where urlError.code == .cancelled {
            return
        } catch let decodingError as DecodingError {
            print("Decoding error:", decodingError)
            errorMessage = "Veri okunamadı (decode)."
        } catch {
            print("Other error:", error)
            errorMessage = "Rezervasyonlar alınırken hata oluştu: \(error.localizedDescription)"
        }
    }
    func cancel(_ reservation: Reservation) async {
            guard !isCancelling else { return }
            isCancelling = true
            errorMessage = nil
            defer { isCancelling = false }

            do {
                try await repo.cancelReservation(id: reservation.id)

                // İstersen direkt listeden çıkar:
                reservations.removeAll { $0.id == reservation.id }

                // veya kesin güncel veri için:
                // reservations = try await repo.fetchMyReservations()

            } catch is CancellationError {
                return
            } catch {
                print("🧨 Cancel error:", error)
                errorMessage = "İptal sırasında hata oluştu: \(error.localizedDescription)"
            }
        }

}
