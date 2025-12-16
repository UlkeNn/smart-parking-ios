//
//  NewReservationViewModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 1.12.2025.
//

import Foundation
import Combine

@MainActor
final class NewReservationViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var spots: [ParkingSpot] = []
    @Published var selectedSpot: ParkingSpot?
    @Published var successMessage: String?

    var spotsByLane: [String: [ParkingSpot]] {
        Dictionary(grouping: spots) { $0.lane }
            .mapValues { $0.sorted { $0.indexInLane < $1.indexInLane } }
    }
    private static let apiDateFormatter: DateFormatter = {
            let f = DateFormatter()
            f.locale = Locale(identifier: "en_US_POSIX")
            f.timeZone = TimeZone(secondsFromGMT: 0)   // backend genelde UTC sever
            f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return f
        }()

    var sortedLanes: [String] {
        spotsByLane.keys.sorted()
    }

    private let parkingId: String
    private let spotRepo: ParkingSpotRepository
    private let reservationRepo: ReservationRepository
    private let tokenProvider: () -> String?
    
    init(parkingId: String,
         spotRepo: ParkingSpotRepository = DefaultParkingSpotRepository(),
         reservationRepo: ReservationRepository = DefaultReservationRepository(),
         tokenProvider: @escaping () -> String?
    ) {
        self.parkingId = parkingId
        self.spotRepo = spotRepo
        self.reservationRepo = reservationRepo
        self.tokenProvider = tokenProvider
    }
    
    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            spots = try await spotRepo.fetchSpots(parkingLotId: parkingId, token: tokenProvider())
            print("✅ \(spots.count) adet spot yüklendi")
        } catch {
            print("❌ Spot yüklenirken hata:", error)
            errorMessage = "Park alanları yüklenemedi."
        }
        isLoading = false
    }


    // REZERVASYON OLUŞTURMA
    func createReservation(
        vehicleId: String,
        startDate: Date,
        endDate: Date
    ) async {
        guard let spot = selectedSpot else {
            errorMessage = "Lütfen bir park yeri seçin."
            return
        }

        guard endDate > startDate else {
            errorMessage = "Bitiş saati başlangıçtan sonra olmalı."
            return
        }

        let f = Self.apiDateFormatter
        let startString = f.string(from: startDate)
        let endString   = f.string(from: endDate)

        let req = CreateReservationRequest(
            parkingSpotId: spot.id,
            vehicleId: vehicleId,
            reservedStart: startString,
            reservedEnd: endString
        )

        do {
            let reservation = try await reservationRepo.createReservation(req)
            successMessage = "Rezervasyon oluşturuldu: \(reservation.parkingSpotCode)"
        } catch {
            errorMessage = "Rezervasyon oluşturulamadı: \(error.localizedDescription)"
        }
    }

}
