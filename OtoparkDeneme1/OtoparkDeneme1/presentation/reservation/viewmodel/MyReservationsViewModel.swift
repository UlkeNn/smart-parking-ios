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
    
    @MainActor
    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            reservations = try await repo.fetchMyReservations()

        } catch is CancellationError {
            // View kapandı / task iptal edildi -> normal, sessiz geç
            return

        } catch let urlError as URLError where urlError.code == .cancelled {
            // NSURLErrorDomain Code=-999
            return

        } catch let decodingError as DecodingError {
            print("🧨 Decoding error:", decodingError)
            errorMessage = "Veri okunamadı (decode)."

        } catch {
            print("🧨 Other error:", error)
            errorMessage = "Rezervasyonlar alınırken hata oluştu: \(error.localizedDescription)"
        }
    }}
