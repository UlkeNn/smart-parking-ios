//
//  AppApperance.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 29.10.2025.
//

import UIKit
import SwiftUI

enum AppAppearance {
    static func configure() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "ButtonBGColorOnB")!

        func style(_ item: UITabBarItemAppearance) {
            item.selected.iconColor = UIColor(named: "Gray")!
            item.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColorOnB2")!]
            item.normal.iconColor = UIColor(named: "TextColorOnB")!
            item.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "TextColorOnB")!]
        }

        style(appearance.stackedLayoutAppearance)
        style(appearance.inlineLayoutAppearance)
        style(appearance.compactInlineLayoutAppearance)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
