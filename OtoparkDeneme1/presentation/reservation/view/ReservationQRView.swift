//
//  ReservationQRView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 6.01.2026.
//

import SwiftUI
enum Route: Hashable {
    case reservationQR(reservation: Reservation)
}


struct ReservationQRView: View {
    let reservation: Reservation

    var body: some View {
        VStack(spacing: 16) {
            Text("Rezervasyon Onaylandı ✅")
                .font(.title2.bold())

            Text(reservation.parkingLotName!)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            if let code = reservation.qrCode,
               let img = QRCodeGenerator.makeImage(from: code) {
                Image(uiImage: img)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else {
                Text("QR oluşturulamadı")
                    .foregroundStyle(.red)
            }

            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Park Yeri: \(reservation.parkingSpotCode)")
                    Text("Plaka: \(reservation.vehiclePlate ?? "-")")
                }
                .font(.callout)
                Spacer()
            }

            Spacer()
        }
        .padding()
        .navigationTitle("QR Kod")
        .navigationBarTitleDisplayMode(.inline)
    }
}
