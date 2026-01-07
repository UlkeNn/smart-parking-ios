//
//  ParkingMapViewModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 31.10.2025.
//
import SwiftUI
import Foundation
import MapKit
import CoreLocation
import Combine


@MainActor
final class ParkingMapViewModel: NSObject, ObservableObject {
    @Published var parkings: [Parking] = []
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var selected: Parking?
    @Published var userLocation: CLLocationCoordinate2D?   // KULLANICI KONUMU
    @Published var showLocationAlert = false

    private let repo: ParkingRepository
    private let locationManager = CLLocationManager()       // KONUM YÖNETİCİSİ

    init(repo: ParkingRepository = DefaultParkingRepository()) {
        self.repo = repo
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // ⬇️ Artık async ve token alıyor
    func load(token: String?) async {
        do {
            let all = try await repo.fetchParkings(token: token)
            self.parkings = all
            updateCameraToFitAll()
            print("Loaded \(all.count) parkings from backend")
        } catch {
            print("Parking load error:", error)
        }
    }

    func requestLocation() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func updateCameraToFitAll(padding: Double = 6000) {
        guard !parkings.isEmpty else { return }

        var minLat =  90.0, maxLat = -90.0, minLon = 180.0, maxLon = -180.0
        for p in parkings {
            minLat = min(minLat, p.latitude); maxLat = max(maxLat, p.latitude)
            minLon = min(minLon, p.longitude); maxLon = max(maxLon, p.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let latMeters = CLLocation(
            latitude: minLat,
            longitude: center.longitude
        ).distance(from: CLLocation(latitude: maxLat, longitude: center.longitude))

        let lonMeters = CLLocation(
            latitude: center.latitude,
            longitude: minLon
        ).distance(from: CLLocation(latitude: center.latitude, longitude: maxLon))

        let dist = max(latMeters, lonMeters) + padding

        cameraPosition = .region(
            .init(center: center,
                  latitudinalMeters: dist,
                  longitudinalMeters: dist)
        )
    }

    func handleUserLocationButtonTap() { // KULLANICI KONUMA İZİN VERMEZSE
        let status = locationManager.authorizationStatus

        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            if let loc = userLocation {
                cameraPosition = .region(
                    .init(center: loc,
                          latitudinalMeters: 1000,
                          longitudinalMeters: 1000)
                )
            }

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .denied, .restricted:
            showLocationAlert = true

        @unknown default:
            break
        }
    }
}

// CLLocationManagerDelegate
extension ParkingMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            showLocationAlert = true
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }
        Task { @MainActor in
            self.userLocation = last.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error:", error)
    }
}
