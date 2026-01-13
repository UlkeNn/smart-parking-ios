//
//  DateSelectionSheet.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 8.12.2025.
//

import SwiftUI

struct DateSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State var startDate: Date
    @State var endDate: Date

    var onConfirm: (Date, Date) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Giriş") {
                    DatePicker(
                        "Tarih & saat",
                        selection: $startDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }

                Section("Çıkış") {
                    DatePicker(
                        "Tarih & saat",
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                Section("Süre") {   //Kullanıcıya ne kadar süre rezerve ettiği gösterilsin.
                    let minutes = Int(endDate.timeIntervalSince(startDate) / 60)
                    let hours = minutes / 60
                    let rem = minutes % 60

                    HStack {
                        Text("Toplam")
                        Spacer()
                        if minutes <= 0 {
                            Text("—")
                                .foregroundStyle(.secondary)
                        } else if rem == 0 {
                            Text("\(hours) saat")
                                .font(.headline)
                        } else {
                            Text("\(hours) saat \(rem) dk")
                                .font(.headline)
                        }
                    }
                }

            }
            .navigationTitle("Tarih Seç")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("İptal") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Tamam") {
                        onConfirm(startDate, endDate)
                        dismiss()
                    }
                }
            }
        }
        .environment(\.locale, Locale(identifier: "tr_TR"))//Artık tarihler ingilizce gözükmeyecek
    }
}

