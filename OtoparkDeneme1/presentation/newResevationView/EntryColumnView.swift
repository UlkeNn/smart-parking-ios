//
//  EntryColumnView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 1.12.2025.
//

import Foundation
import SwiftUI
struct EntryColumnView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Entry")
                .foregroundColor(.white)
                .font(.subheadline)
            
            ForEach(0..<4) { _ in
                Image(systemName: "chevron.down")
                    .foregroundColor(.white)
            }
        }
    }
}
