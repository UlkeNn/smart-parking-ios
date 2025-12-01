//
//  HomeView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 20.10.2025.
//


import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool
    
    // Backend’ten gelecek otoparklar
    @StateObject private var vm = ParkingListViewModel()
    
    var filteredParkings: [Parking] {
        if searchText.isEmpty { return vm.parkings }
        return vm.parkings.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            // Arka plan
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // 🔍 Arama kutusu
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Otopark ara...", text: $searchText)
                            .focused($isSearchFocused)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(14)
                    .padding(.horizontal)
                    
                    
                    // 📍 Başlık
                    HStack {
                        Text("Sana en yakın otoparklar")
                            .font(.headline)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // 🔥 Gerçek otopark listesi (backend)
                    VStack(spacing: 14) {
                        ForEach(filteredParkings) { parking in
                            ParkingCardView(parking: parking)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            if vm.isLoading {
                ProgressView("Yükleniyor...")
                    .tint(.white)
            }
        }
        .onTapGesture {
            isSearchFocused = false
        }
        .task {
            await vm.load()
        }
    }
}

struct ParkingCardView: View {
    let parking: Parking
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(parking.name)
                .font(.headline)
                .foregroundColor(.white)
            
            if let address = parking.address {
                Text(address)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 16) {
                Label("\(String(format: "%.3f", parking.latitude)), \(String(format: "%.3f", parking.longitude))", systemImage: "mappin.and.ellipse")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(16)
    }
}


#Preview {
    HomeView()
}
