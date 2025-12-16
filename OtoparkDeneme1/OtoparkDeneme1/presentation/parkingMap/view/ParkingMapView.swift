//
//  ParkingMapView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 31.10.2025.
//

import SwiftUI
import MapKit

struct ParkingMapView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var vm = ParkingMapViewModel()

    var body: some View {
        Map(position: $vm.cameraPosition) {
            ForEach(vm.parkings) { p in
                Annotation(p.name, coordinate: p.coordinate) {
                    VStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title2)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.gray)

                        // Artık availabilityText kullanıyoruz
                        Text(p.availabilityText)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                .ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 6)
                            )
                    }
                    .onTapGesture { vm.selected = p }
                }
                .annotationTitles(.hidden)
            }

            // iOS 17+ SwiftUI Map’te UserAnnotation mavi noktayı çizer
            UserAnnotation()
        }
        .mapStyle(.standard(elevation: .realistic))
        .ignoresSafeArea(edges: .bottom)
        .task {
            // ⬇️ TOKEN’I BURADAN VERİYORUZ
            await vm.load(token: session.token)
            vm.requestLocation()
        }
        // Yerleşik harita kontrolleri
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
        .sheet(item: $vm.selected) { p in
            ParkingDetailSheet(parking: p)
                .presentationDetents([.height(220), .medium])
        }
        .navigationTitle("Otoparkların Haritası")
        .navigationBarTitleDisplayMode(.inline)
        // 🔹 Navigation bar görünüm düzeltmeleri
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("Konum İzni Gerekli", isPresented: $vm.showLocationAlert) {
            Button("Ayarları Aç") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("İptal", role: .cancel) {}
        } message: {
            Text("Yakınınızdaki otoparkları gösterebilmemiz için konum iznine ihtiyacımız var.")
        }
    }
}

private struct ParkingDetailSheet: View {
    let parking: Parking

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "parkingsign.circle")
                Text(parking.name)
                    .font(.headline)
                Spacer()
            }

            if let addr = parking.address {
                Text(addr)
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 16) {
                Label(parking.availabilityText, systemImage: "car.fill")
                if let c = parking.capacity {
                    Label("Kapasite: \(c)", systemImage: "gauge")
                }
            }
            .font(.subheadline)

            Link(
                destination: URL(
                    string: "http://maps.apple.com/?saddr=Current%20Location&daddr=\(parking.latitude),\(parking.longitude)&dirflg=d"
                )!
            ) {
                Text("Haritalarda Aç")
                    .foregroundStyle(Color("TextColorOnB"))
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ParkingMapView()
}
