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
    }
}

