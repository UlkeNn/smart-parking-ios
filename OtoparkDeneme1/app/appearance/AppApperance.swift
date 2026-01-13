//
//  AppApperance.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 29.10.2025.
//
import SwiftUI
import UIKit

enum AppAppearance {
    static func configureTabBar() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        let bg = UIColor(named: "ButtonBGColorOnB") ?? .black
        let selected = UIColor(named: "Gray") ?? .white
        let unselected = UIColor(named: "TextColorOnB") ?? UIColor.white.withAlphaComponent(0.6)

        appearance.backgroundColor = bg
        
        // ✅ Boşluğu ve üst çizgiyi (shadow) tamamen yok etmek için:
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()

        func apply(_ item: UITabBarItemAppearance) {
            item.selected.iconColor = selected
            item.selected.titleTextAttributes = [.foregroundColor: selected]
            item.normal.iconColor = unselected
            item.normal.titleTextAttributes = [.foregroundColor: unselected]
        }

        apply(appearance.stackedLayoutAppearance)
        apply(appearance.inlineLayoutAppearance)
        apply(appearance.compactInlineLayoutAppearance)

        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance // iOS 15+ için kritik
    }
}
