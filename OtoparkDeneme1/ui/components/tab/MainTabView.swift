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
            HomeTab()
                .tabItem { Label("Anasayfa", systemImage: "homekit") }
            
            MyReservationsTab()
                .tabItem { Label("Rezervasyonlarım", systemImage: "calendar.badge.clock") }
        }
        // ✅ TabView'un altına kendi rengini döşe ki boşluk kalsa bile aynı renk görünsün
        .background(Color("ButtonBGColorOnB").ignoresSafeArea())
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
        .background(Color("ButtonBGColorOnB"))
        .ignoresSafeArea(.container, edges: .bottom)


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
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case let .reservationQR(reservation):
                        ReservationQRView(reservation: reservation)
                    }
                }
        }
        .background(Color("ButtonBGColorOnB"))
        .ignoresSafeArea(.container, edges: .bottom)

    }
}


#Preview {
    MainTabView()
}
