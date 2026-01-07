//
//  NewReservationsView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 1.12.2025.
//

import SwiftUI


struct NewReservationsView: View {
    let parking: Parking
    let startDate: Date
    let endDate: Date

    @StateObject private var vm: NewReservationViewModel

    // GÖRÜNÜMDE TARİHİ SADECE GÖSTERİYORUZ, SEÇMİYORUZ
    private static let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "tr_TR")
        f.dateStyle = .medium
        f.timeStyle = .short
        return f
    }()

    init(parking: Parking, startDate: Date, endDate: Date) {
        self.parking = parking
        self.startDate = startDate
        self.endDate = endDate

        _vm = StateObject(
            wrappedValue: NewReservationViewModel(
                parkingId: parking.id,
                spotRepo: DefaultParkingSpotRepository(),
                reservationRepo: DefaultReservationRepository(),
                tokenProvider: { UserSession.sharedToken }   // ✅ tekrar token gönder
            )
        )
    }
    var body: some View {
        ZStack {
            // ARKA PLAN
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {

                // BAŞLIK
                VStack(spacing: 4) {
                    Text(parking.name)
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Text("Uygun bir park yeri seçin")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.top, 8)

                // GİRİŞ / ÇIKIŞ ÖZETİ (ONLY DISPLAY)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Başlangıç: \(Self.displayFormatter.string(from: startDate))")
                    Text("Bitiş: \(Self.displayFormatter.string(from: endDate))")
                }
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)

                // İÇERİK (PARK LAYOUT)
                contentView

                // ALT BÖLÜM (BUTON + MESAJLAR)
                bottomSection
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load() }
    }

    // MARK: - İçerik

    @ViewBuilder
    private var contentView: some View {
        if vm.isLoading {
            ProgressView("Park alanları yükleniyor…")
                .tint(.white)
                .frame(maxWidth: .infinity, alignment: .center)
        } else if let err = vm.errorMessage, vm.spots.isEmpty {
            // ❗ HATA MESAJI SADECE BURADA
            Text(err)
                .foregroundColor(.red)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        } else if vm.spots.isEmpty {
            Text("Bu otopark için tanımlı park alanı bulunamadı.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
        } else {
            parkingLayout
                .padding(.top, 8)
        }
    }

    // MARK: - Park Yerleri Layout’u

    private var parkingLayout: some View {
        let lanes = vm.sortedLanes
        let mid = max(lanes.count / 2, 1)
        let left = Array(lanes.prefix(mid))
        let right = Array(lanes.suffix(from: mid))

        return HStack(alignment: .top, spacing: 40) {
            LaneGroupView(
                lanes: left,
                spotsByLane: vm.spotsByLane,
                selectedSpotId: vm.selectedSpot?.id,
                onSelect: { vm.selectedSpot = $0 }
            )

            EntryColumnView()   // senin mevcut görünümün

            LaneGroupView(
                lanes: right,
                spotsByLane: vm.spotsByLane,
                selectedSpotId: vm.selectedSpot?.id,
                onSelect: { vm.selectedSpot = $0 }
            )
        }
    }

    // MARK: - Alt bölüm

    @ViewBuilder
    private var bottomSection: some View {
        VStack(spacing: 12) {
            if let selected = vm.selectedSpot {
                Text("Seçilen park yeri: \(selected.spotCode)")
                    .foregroundColor(.white)

                Button {
                    Task {
                        await vm.createReservation(
                            vehicleId: "f7dfec42-133a-4e80-9ea8-27e2b7a3270b", // şimdilik sabit
                            startDate: startDate,
                            endDate: endDate
                        )
                    }
                } label: {
                    Text("Rezervasyonu Oluştur")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.cyan)
                        .cornerRadius(12)
                        .foregroundColor(.black)
                }
            }

            if let success = vm.successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
            }

            // Hata mesajını SPOT VARSA burada da gösterebilirsin (isteğe bağlı)
            if let err = vm.errorMessage, !vm.spots.isEmpty {
                Text(err)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
