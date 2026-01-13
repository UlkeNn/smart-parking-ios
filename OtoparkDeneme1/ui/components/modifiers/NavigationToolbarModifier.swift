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


enum TabBarTheme {
    static func apply() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        let bg = UIColor(named: "TabBarBGColor") ?? .black
        let selected = UIColor(named: "BGColor") ?? .white
        let unselected = UIColor(named: "ButtonBGColorOnB") ?? UIColor.white.withAlphaComponent(0.6)

        appearance.backgroundColor = bg
        appearance.backgroundEffect = nil   // ✅ blur/material kapat
        appearance.shadowColor = .clear     // ✅ üst çizgi kapat

        // ✅ Stacked (en yaygın)
        appearance.stackedLayoutAppearance.selected.iconColor = selected
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selected]
        appearance.stackedLayoutAppearance.normal.iconColor = unselected
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselected]

        // ✅ Inline (bazı durumlarda devreye girer)
        appearance.inlineLayoutAppearance.selected.iconColor = selected
        appearance.inlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selected]
        appearance.inlineLayoutAppearance.normal.iconColor = unselected
        appearance.inlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselected]

        // ✅ Compact inline (iPhone landscape vb)
        appearance.compactInlineLayoutAppearance.selected.iconColor = selected
        appearance.compactInlineLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selected]
        appearance.compactInlineLayoutAppearance.normal.iconColor = unselected
        appearance.compactInlineLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: unselected]

        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
        tabBar.backgroundColor = bg          // ✅ alt beyaz alanı öldürür
        tabBar.barTintColor = bg             // ✅ ekstra garanti

        tabBar.tintColor = selected
        tabBar.unselectedItemTintColor = unselected
    }
}
