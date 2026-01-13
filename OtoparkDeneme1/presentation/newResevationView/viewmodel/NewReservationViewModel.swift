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

    @Published var createdReservation: Reservation? // qr'a geçiş için lazımdır
    @Published var unavailableSpotIds: Set<UUID> = []

    /// Sadece backend'in döndüğü fiyat. Backend göndermiyorsa nil kalsın.
    @Published var finalPrice: Double? = nil

    var spotsByLane: [String: [ParkingSpot]] {
        Dictionary(grouping: spots) { $0.lane }
            .mapValues { $0.sorted { $0.indexInLane < $1.indexInLane } }
    }

    var sortedLanes: [String] {
        spotsByLane.keys.sorted()
    }

    private let parkingId: String
    private let spotRepo: ParkingSpotRepository
    private let reservationRepo: ReservationRepository
    private let tokenProvider: () -> String?

    init(
        parkingId: String,
        spotRepo: ParkingSpotRepository = DefaultParkingSpotRepository(),
        reservationRepo: ReservationRepository = DefaultReservationRepository(),
        tokenProvider: @escaping () -> String?
    ) {
        self.parkingId = parkingId
        self.spotRepo = spotRepo
        self.reservationRepo = reservationRepo
        self.tokenProvider = tokenProvider
    }

    /// UI'nın göstereceği fiyat: sadece backend (nil olabilir)
    var displayPrice: Double? { finalPrice }

    // OK artık tarih aralığı ile yükleniyor
    func load(startDate: Date, endDate: Date) async {
        isLoading = true
        errorMessage = nil
        successMessage = nil

        // Yeni aralıkta önceki fiyatı gösterme (yanlış anlaşılmasın)
        finalPrice = nil

        do {
            async let spotsTask = spotRepo.fetchSpots(
                parkingLotId: parkingId,
                token: tokenProvider()
            )

            async let unavailableTask = reservationRepo.fetchUnavailableReservations(
                parkingLotId: parkingId,
                startDate: startDate,
                endDate: endDate
            )

            let (fetchedSpots, conflictingReservations) = try await (spotsTask, unavailableTask)

            self.spots = fetchedSpots
            self.unavailableSpotIds = Set(conflictingReservations.map { $0.parkingSpotId })

            // seçili spot artık doluysa temizle
            if let selected = selectedSpot, unavailableSpotIds.contains(selected.id) {
                selectedSpot = nil
            }

            print("✅ spots:", spots.count, "unavailable:", unavailableSpotIds.count)

        } catch {
            print("❌ load error:", error)
            errorMessage = "Park alanları yüklenemedi: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func isUnavailable(_ spot: ParkingSpot) -> Bool {
        unavailableSpotIds.contains(spot.id)
    }

    func selectSpot(_ spot: ParkingSpot) {
        if isUnavailable(spot) {
            errorMessage = "Bu saat aralığında bu park yeri dolu."
            return
        }
        selectedSpot = spot
        errorMessage = nil
    }

    // REZERVASYON OLUŞTURMA (aynı)
    private static let apiBodyDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()

    func createReservation(vehicleId: UUID, startDate: Date, endDate: Date) async {
        guard let spot = selectedSpot else {
            errorMessage = "Lütfen bir park yeri seçin."
            return
        }

        guard endDate > startDate else {
            errorMessage = "Bitiş saati başlangıçtan sonra olmalı."
            return
        }

        let f = Self.apiBodyDateFormatter
        let req = CreateReservationRequest(
            parkingSpotId: spot.id,
            vehicleId: vehicleId,
            reservedStart: f.string(from: startDate),
            reservedEnd: f.string(from: endDate)
        )

        do {
            let reservation = try await reservationRepo.createReservation(req)
            createdReservation = reservation

            // ✅ sadece backend fiyatı: 0 veya negatifse nil say (istersen kaldır)
            let price = reservation.totalPrice
            finalPrice = price > 0 ? price : nil

            successMessage = "Rezervasyon oluşturuldu: \(reservation.parkingSpotCode ?? "")"
            errorMessage = nil
        } catch {
            errorMessage = "Rezervasyon oluşturulamadı: \(error.localizedDescription)"
        }
    }
}
