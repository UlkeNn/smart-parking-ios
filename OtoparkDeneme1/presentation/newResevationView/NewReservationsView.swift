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
    @EnvironmentObject var session: UserSession
    @State private var goToQR = false
    @StateObject private var vm: NewReservationViewModel

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
                tokenProvider: { UserSession.sharedToken }
            )
        )
    }

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {

                VStack(spacing: 4) {
                    Text(parking.name)
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Text("Uygun bir park yeri seçin")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                .padding(.top, 8)

                VStack(alignment: .leading, spacing: 4) {
                    Text("Başlangıç: \(Self.displayFormatter.string(from: startDate))")
                    Text("Bitiş: \(Self.displayFormatter.string(from: endDate))")

                    Divider().padding(.vertical, 6)

                    if let price = vm.displayPrice {
                        Divider().padding(.vertical, 6)

                        HStack {
                            Text("Rezervasyon Ücreti")
                            Spacer()
                            Text("\(price, specifier: "%.0f") ₺")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }

                }
                .font(.footnote)
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)


                contentView
                bottomSection
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
            
        }
        
        .navigationBarTitleDisplayMode(.inline)
        .task { await vm.load(startDate: startDate, endDate: endDate) }
        .navigationDestination(isPresented: $goToQR) {
            if let r = vm.createdReservation {
                ReservationQRView(reservation: r)
                    .toolbar(.hidden, for: .tabBar)
            }
        }


    }

    @ViewBuilder
    private var contentView: some View {
        if vm.isLoading {
            ProgressView("Park alanları yükleniyor…")
                .tint(.white)
                .frame(maxWidth: .infinity, alignment: .center)
        } else if let err = vm.errorMessage, vm.spots.isEmpty {
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
            scrollableParkingLayout.padding(.top, 8)
        }
    }

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
                unavailableSpotIds: vm.unavailableSpotIds,
                onSelect: { vm.selectSpot($0) }
            )

            EntryColumnView()

            LaneGroupView(
                lanes: right,
                spotsByLane: vm.spotsByLane,
                selectedSpotId: vm.selectedSpot?.id,
                unavailableSpotIds: vm.unavailableSpotIds,
                onSelect: { vm.selectSpot($0) }
            )
        }
    }
    private var scrollableParkingLayout: some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                parkingLayout
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    // İçerik, görünür alanı en az doldursun ki “boşluk” hissi olmasın
                    .frame(
                        minWidth: geo.size.width,
                        minHeight: geo.size.height,
                        alignment: .topLeading
                    )
            }
            .scrollIndicators(.visible) // istersen .hidden
            .background(Color.white.opacity(0.03))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        // scroll alanı ekranı “kaplasın” ki alttaki butonu aşağı itmesin
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }


    @ViewBuilder
    private var bottomSection: some View {
        VStack(spacing: 12) {
            if let selected = vm.selectedSpot {
                Text("Seçilen park yeri: \(selected.spotCode)")
                    .foregroundColor(.white)

                Button {
                    Task {
                        guard let vehicleId = session.selectedVehicleId else {
                            vm.errorMessage = "Lütfen önce bir araç seçin."
                            return
                        }

                        await vm.createReservation(
                            vehicleId: vehicleId,
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
                .disabled(session.selectedVehicleId == nil)
                .opacity(session.selectedVehicleId == nil ? 0.55 : 1.0)

            }

            if let success = vm.successMessage {
                Text(success)
                    .foregroundColor(.green)
                    .multilineTextAlignment(.center)
            }
            
            if vm.createdReservation != nil {
                Button {
                    goToQR = true
                } label: {
                    Text("QR'ı Göster")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.15))
                        .cornerRadius(12)
                        .foregroundColor(.white)
                }
            }

            if let err = vm.errorMessage, !vm.spots.isEmpty {
                Text(err)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
