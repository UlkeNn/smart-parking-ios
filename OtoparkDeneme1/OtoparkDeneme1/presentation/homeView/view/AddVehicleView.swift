//
//  AddVehicleView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 13.12.2025.
//

import SwiftUI

struct AddVehicleSheet: View {
    @EnvironmentObject var session: UserSession
    @ObservedObject var vehicleVM: MyVehiclesViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var plateNumber: String = ""
    @State private var type: VehicleType = .standard
    @State private var isSaving = false
    @State private var errorText: String?

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Araç Ekle")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                    Spacer()
                    Button("Kapat") { dismiss() }
                        .foregroundColor(.white)
                }
                .padding(.top, 6)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Plaka")
                        .font(.caption)
                        .foregroundColor(.gray)

                    TextField("Buraya plaka giriniz:", text: $plateNumber)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(true)
                        .padding()
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)
                        .foregroundColor(.white)

                    Text("Araç Tipi")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 6)

                    Picker("Araç Tipi", selection: $type) {
                        Text("Standart").tag(VehicleType.standard)
                        Text("Elektrikli").tag(VehicleType.ev)
                        Text("Motorsiklet").tag(VehicleType.motorcycle)
                    }
                    .pickerStyle(.segmented)
                }

                if let errorText {
                    Text(errorText)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Button {
                    Task {
                        isSaving = true
                        errorText = nil
                        defer { isSaving = false }

                        do {
                            try await vehicleVM.addVehicle(
                                plateNumber: plateNumber,
                                type: type,
                                session: session
                            )
                            dismiss()
                        } catch {
                            errorText = error.localizedDescription
                        }
                    }
                } label: {
                    HStack {
                        Spacer()
                        if isSaving {
                            ProgressView().tint(.white)
                        } else {
                            Text("Kaydet")
                                .font(.headline)
                                .tint(.white)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 12)
                    .background(Color.white.opacity(0.14))
                    .cornerRadius(14)
                }
                .buttonStyle(.plain)
                .disabled(isSaving || plateNumber.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
        }
    }
}
/*
#Preview {
    AddVehicleView()
}
*/
