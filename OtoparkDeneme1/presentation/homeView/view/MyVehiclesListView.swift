//
//  MyVehiclesListView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 13.12.2025.
//

import SwiftUI

struct MyVehiclesListView: View {
    @EnvironmentObject var session: UserSession
    @ObservedObject var vehicleVM: MyVehiclesViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            List {
                // Header boşluğu: üstte kendi başlığımız var
                Color.clear
                    .frame(height: 72)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                ForEach(vehicleVM.vehicles) { v in
                    Button {
                        session.selectedVehicleId = v.id
                        session.persistSelectedVehicle()
                        vehicleVM.setSelectedVehicleId(v.id)
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(v.plateNumber)
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text(v.type.displayName)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            if session.selectedVehicleId == v.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                    .font(.title3)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            Task { await vehicleVM.delete(vehicle: v, session: session) }
                        } label: {
                            Label("Sil", systemImage: "trash")
                        }
                    }

                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden) // ✅ List beyazlığını kapatır
            .background(Color.clear)

            // ✅ Custom header (navbar yerine)
            VStack {
                HStack(alignment: .top) {
                    Text("Araç Seç")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)

                    Spacer()

                    Button("Kapat") { dismiss() }
                        .foregroundColor(.white)
                        .padding(.top, 6)
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)

                Spacer()
            }
        }
    }
}

/*
#Preview {
    MyVehiclesListView()
}
*/
