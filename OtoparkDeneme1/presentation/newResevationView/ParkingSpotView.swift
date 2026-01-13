//
//  ParkingSpotView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 1.12.2025.
//

//SPOT BUTONUMUZ

import Foundation
import SwiftUI

struct ParkingSpotView: View {
    let spot: ParkingSpot
    let isSelected: Bool
    let isUnavailable: Bool          // ✅ YENİ
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(style: StrokeStyle(
                        lineWidth: isSelected ? 2 : 1,
                        dash: isSelected ? [6] : [4]
                    ))
                    .foregroundColor(borderColor)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(backgroundColor)
                    )
                    .frame(width: 80, height: 50)

                VStack(spacing: 4) {
                    if isSelected {
                        Text("Selected")
                            .font(.caption)
                            .foregroundColor(.cyan)
                    } else if isUnavailable {
                        Text("Dolu")
                            .font(.caption2)
                            .foregroundColor(.red.opacity(0.9))
                    } else {
                        Image(systemName: "car.fill")
                            .foregroundColor(.white)
                            .opacity(spot.occupied ? 0.3 : 0.9)
                    }

                    Text(spot.spotCode)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(spot.occupied || isUnavailable)                 // ✅ değişti
        .opacity((spot.occupied || isUnavailable) ? 0.35 : 1.0)   // ✅ değişti
        .overlay(alignment: .bottomTrailing) {
            if spot.type == .handicapped {
                Image(systemName: "figure.roll")
                    .font(.caption2)
                    .padding(4)
            } else if spot.type == .evCharging {
                Image(systemName: "bolt.fill")
                    .font(.caption2)
                    .padding(4)
            }
        }
    }

    private var borderColor: Color {
        if isSelected { return .cyan }
        if spot.occupied { return .gray }
        if isUnavailable { return .red.opacity(0.8) } // ✅ YENİ

        switch spot.type {
        case .standard: return .white.opacity(0.4)
        case .evCharging: return .green
        case .handicapped: return .blue
        }
    }

    private var backgroundColor: Color {
        if isSelected { return Color.white.opacity(0.12) }
        if spot.occupied { return Color.white.opacity(0.05) }
        if isUnavailable { return Color.red.opacity(0.10) } // ✅ YENİ

        return Color.white.opacity(0.02)
    }
}
