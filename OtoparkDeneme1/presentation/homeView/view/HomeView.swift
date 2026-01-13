//
//  HomeView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 20.10.2025.
//
enum HomeRoute: Hashable {
    case newReservation(parking: Parking, start: Date, end: Date, vehicleId: UUID)
    case vehiclesList
}

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    @FocusState private var isSearchFocused: Bool

    @EnvironmentObject var session: UserSession

    //  init yok, AppContainer yok
    @StateObject private var vehicleVM = MyVehiclesViewModel()
    @StateObject private var vm = ParkingListViewModel()
    
    @State private var showingVehiclesSheet = false


    @State private var path: [HomeRoute] = []
    @State private var showingDateSheet = false
    @State private var selectedParking: Parking?

    var filteredParkings: [Parking] {
        if searchText.isEmpty { return vm.parkings }
        return vm.parkings.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        VehicleCardView(
                            vehicleVM: vehicleVM,
                            vehicle: vehicleVM.activeVehicle,
                            isLoading: vehicleVM.isLoading,
                            onExploreTap: { showingVehiclesSheet = true }
                        )
                        .environmentObject(session)
                        .padding(.horizontal)

                       
                        VStack(spacing: 14) {
                            ForEach(filteredParkings) { parking in
                                ParkingCardView(parking: parking) {
                                    selectedParking = parking
                                    showingDateSheet = true
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 6)
                }

                if vm.isLoading {
                    ProgressView("Yükleniyor...")
                        .tint(.white)
                }
            }
            .task {
                await vm.load()

                // ✅ token zaten session’da var
                await vehicleVM.load(token: session.token)

                // ✅ seçili araç id’sini session’a yaz (ilk yüklemede)
                if session.selectedVehicleId == nil,
                   let first = vehicleVM.vehicles.first {
                    session.selectedVehicleId = first.id
                    session.persistSelectedVehicle()
                }

                // ✅ session’da seçili araç varsa vehicleVM’e yansıt
                if let id = session.selectedVehicleId {
                    vehicleVM.setSelectedVehicleId(id)
                }
            }
            .sheet(isPresented: $showingVehiclesSheet) {
                NavigationStack {
                    MyVehiclesListView(vehicleVM: vehicleVM)
                        .environmentObject(session)
                        .presentationBackground(.clear)
                }
            }

            .sheet(isPresented: $showingDateSheet) {
                if let parking = selectedParking {
                    let now = Date()
                    let oneHourLater = Calendar.current.date(byAdding: .hour, value: 1, to: now)!

                    DateSelectionSheet(startDate: now, endDate: oneHourLater) { start, end in
                        let vehicleId =
                            session.selectedVehicleId
                            ?? vehicleVM.activeVehicle?.id
                        ?? UUID(uuidString: "f7dfec42-133a-4e80-9ea8-27e2b7a3270b")! // fallback test

                        path.append(.newReservation(
                            parking: parking,
                            start: start,
                            end: end,
                            vehicleId: vehicleId
                        ))
                    }
                }
            }
            .navigationDestination(for: HomeRoute.self) { route in
                switch route {
                case let .newReservation(parking, start, end, _):
                    NewReservationsView(
                        parking: parking,
                        startDate: start,
                        endDate: end
                    )

                case .vehiclesList:
                    MyVehiclesListView(vehicleVM: vehicleVM)
                }
            }
        }
    }
}

struct ParkingCardView: View {
    let parking: Parking
    var onReserveTap: () -> Void
    
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
                Label(
                    "\(String(format: "%.3f", parking.latitude)), \(String(format: "%.3f", parking.longitude))",
                    systemImage: "mappin.and.ellipse"
                )
                .foregroundColor(.gray)
                .font(.caption)
            }
            
            Button("Rezervasyon Yap") {
                onReserveTap()
            }
            .font(.subheadline.weight(.semibold))
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .background(Color.white.opacity(0.15))
            .cornerRadius(10)
            .buttonStyle(.plain)
            .padding(.top, 8)
            
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(16)
    }
}

#Preview {
    HomeView()
}
