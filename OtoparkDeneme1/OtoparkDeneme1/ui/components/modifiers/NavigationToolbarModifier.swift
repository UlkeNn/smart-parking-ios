//
//  NavigationToolbarModifier.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 29.10.2025.
//

import SwiftUI

struct NavigationToolbarModifier<Provider: ToolbarProviding>: ViewModifier {
    let provider: Provider

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { provider.leading }
                ToolbarItem(placement: .navigationBarTrailing) { provider.trailing }
            }
            .toolbarBackground(Color.black.opacity(0.8), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

extension View {
    func navigationToolbar<P: ToolbarProviding>(_ provider: P) -> some View {
        modifier(NavigationToolbarModifier(provider: provider))
    }
}
extension View {
    func tabBarStyled() -> some View {
        self
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarBackground(Color.indigo, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            .tint(.white)
    }
}
