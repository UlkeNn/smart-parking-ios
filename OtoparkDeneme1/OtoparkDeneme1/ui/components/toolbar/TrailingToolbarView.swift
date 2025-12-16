//
//  TrailingToolbarView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 29.10.2025.
//

import SwiftUI


struct TrailingToolbarView: View {
    @EnvironmentObject private var session: UserSession
    var onTap: () -> Void = {}
    var body: some View {
    Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.white.opacity(0.8))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Bulunduğun bölge")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("\(session.user.district), \(session.user.province)")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(.plain) 

    }
}
#Preview {
    TrailingToolbarView()
}
