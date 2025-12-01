//
//  TabView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 23.10.2025.
//
import UIKit
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeTab()   // kendi NavigationStack’i içinde
                .tabItem { Label("Anasayfa", systemImage: "homekit") }
            MyReservationsTab()   // 🔹 Yeni sekme
                            .tabItem {
                                Label("Rezervasyonlarım", systemImage: "calendar.badge.clock")
                            }
            SettingsTab()
                .tabItem { Label("Ayarlar", systemImage: "gear") }
        }
        .tabBarStyled()
    }
}

// MARK: - Home tab
struct HomeTab: View {
    @State private var showMap = false
    @State private var showProfile = false
    var body: some View {
        NavigationStack {
            HomeView()
                .navigationToolbar(
                    DefaultToolbarProvider(
                        onLeadingTap: { showProfile = true },
                        onTrailingTap: { showMap = true })
                )
                .navigationDestination(isPresented: $showProfile) {
                    UserProfileView()
                        .toolbar(.hidden, for: .tabBar) // istersen gizle
                }
                .navigationDestination(isPresented: $showMap) {
                    ParkingMapView()
                        .toolbar(.hidden, for: .tabBar)//Tabbar saklanır
                }
        }
    }
}
// MARK: - Rezervasyonlar tab
struct MyReservationsTab: View {
    @State private var showMap = false
    @State private var showProfile = false
    var body: some View {
        NavigationStack {
            MyReservationsView()
                .navigationTitle("Rezervasyonlarım")
                .navigationToolbar(
                    DefaultToolbarProvider(
                        onLeadingTap: { showProfile = true },
                        onTrailingTap: { showMap = true })
                )
                .navigationDestination(isPresented: $showProfile) {
                    UserProfileView()
                        .toolbar(.hidden, for: .tabBar) // istersen gizle
                }
                .navigationDestination(isPresented: $showMap) {
                    ParkingMapView()
                        .toolbar(.hidden, for: .tabBar)//Tabbar saklanır
                }
        }
    }
}
// MARK: - Settings tab
struct SettingsTab: View {
    var body: some View {
        NavigationStack {
            Settings()
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(UserSession.mock())
}
