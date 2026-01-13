//
//  MyReservationsView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 26.11.2025.
//


import SwiftUI

struct MyReservationsView: View {
    @StateObject private var vm = MyReservationsViewModel()
    @State private var path: [Route] = []
    @State private var showCancelAlert = false
    @State private var selectedToCancel: Reservation?


    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "tr_TR")
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            NavigationStack(path: $path) {
                Group {
                    if vm.isLoading {
                        ProgressView("Yükleniyor…")
                    } else if let error = vm.errorMessage {
                        VStack(spacing: 8) {
                            Text(error).foregroundStyle(.red)
                            Button("Tekrar dene") { Task { await vm.load() } }
                        }
                    } else if vm.reservations.isEmpty {
                        Text("Hiç rezervasyonun yok.")
                            .foregroundStyle(.white)
                    } else {
                        List(vm.reservations) { r in
                            reservationRow(r)
                                .listRowBackground(Color.black.opacity(0.001))
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {

                                    if r.active {

                                    Button(role: .destructive) {
                                        selectedToCancel = r
                                        showCancelAlert = true
                                    } label: {
                                        Label("İptal Et", systemImage: "xmark.circle")
                                    }
                                    .tint(Color.gray)
                                    }
                                    
                                                         
                                }
                                
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .alert("Rezervasyonu iptal etmek istiyor musun?", isPresented: $showCancelAlert) {
                            Button("Vazgeç", role: .cancel) {
                                selectedToCancel = nil
                            }

                            Button("İptal Et", role: .destructive) {
                                guard let r = selectedToCancel else { return }
                                Task {
                                    await vm.cancel(r)
                                    selectedToCancel = nil
                                }
                            }
                        } message: {
                            if let r = selectedToCancel {
                                Text("\(r.parkingLotName ?? "-") • \(r.parkingSpotCode ?? "-")\n\(dateFormatter.string(from: r.reservedStart)) → \(dateFormatter.string(from: r.reservedEnd))")
                            } else {
                                Text("Bu işlem geri alınamaz.")
                            }
                        }

                    }
                }
                .navigationTitle("Rezervasyonlarım")
                .navigationBarTitleDisplayMode(.large)
                .task { await vm.load() }
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .reservationQR(let reservation):
                        ReservationQRView(reservation: reservation)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func reservationRow(_ r: Reservation) -> some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack {
                Text("\(r.parkingLotName ?? "-")  •  \(r.parkingSpotCode ?? "-")")
                    .font(.headline)
                    .foregroundStyle(.white)

                Spacer()

                Text(r.active ? "Aktif" : "Pasif")
                    .font(.subheadline)
                    .foregroundStyle(r.active ? .green : .white.opacity(0.8))
            }

            Text("Araç: \(r.vehiclePlate ?? "-")")
                .foregroundStyle(.white.opacity(0.9))

            Text("\(dateFormatter.string(from: r.reservedStart))  ➝  \(dateFormatter.string(from: r.reservedEnd))")
                .foregroundStyle(.white)

            HStack {
                Text(String(format: "%.2f ₺", r.totalPrice))
                    .foregroundStyle(.white)

                Spacer()

                // QR Kod Al butonu (qrCode varsa göster)
                if let qr = r.qrCode, !qr.isEmpty {
                    Button {
                        path.append(.reservationQR(reservation: r))
                    } label: {
                        Text("QR Kod Al")
                            .font(.caption.bold())
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
        )
    }
}
#Preview {
    MyReservationsView()
}
