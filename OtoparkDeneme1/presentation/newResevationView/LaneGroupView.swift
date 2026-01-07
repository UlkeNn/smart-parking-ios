//
//  LaneGroupView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 1.12.2025.
//

import Foundation
import SwiftUI

struct LaneGroupView: View {
    let lanes: [String]
    let spotsByLane: [String: [ParkingSpot]]
    let selectedSpotId: String?
    let onSelect: (ParkingSpot) -> Void
    
    var body: some View {
        HStack(alignment: .top, spacing: 28) {
            ForEach(lanes, id: \.self) { lane in
                VStack(spacing: 16) {
                    ForEach(spotsByLane[lane] ?? []) { spot in
                        ParkingSpotView(
                            spot: spot,
                            isSelected: selectedSpotId == spot.id,
                            onSelect: { onSelect(spot) }
                        )
                    }
                }
            }
        }
    }
}
