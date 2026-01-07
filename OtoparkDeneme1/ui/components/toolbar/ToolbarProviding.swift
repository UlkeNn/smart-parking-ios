//
//  ToolbarProviding.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 29.10.2025.
//

import SwiftUI

protocol ToolbarProviding {
    associatedtype Leading: View
    associatedtype Trailing: View
    @ViewBuilder var leading: Leading { get }
    @ViewBuilder var trailing: Trailing { get }
}

struct DefaultToolbarProvider: ToolbarProviding {
    var onLeadingTap: () -> Void = {}
    var onTrailingTap: () -> Void = {}
    
    var leading: some View { LeadingToolbarView(onTap: onLeadingTap) }
    var trailing: some View { TrailingToolbarView(onTap: onTrailingTap) }
}

