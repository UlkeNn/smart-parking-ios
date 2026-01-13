//
//  MyVehiclesViewModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 13.12.2025.
//

import Foundation
import Combine

@MainActor
final class MyVehiclesViewModel: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // ✅ artık UUID
    @Published private(set) var selectedVehicleId: UUID?

    private let repo: VehicleRepository

    init(repo: VehicleRepository = DefaultVehicleRepository()) {
        self.repo = repo
    }

    func load(token: String?) async {
        guard let token else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let fetched = try await repo.fetchMyVehicles(token: token)
            vehicles = fetched

            // selected yoksa -> ilkini seç
            if selectedVehicleId == nil {
                selectedVehicleId = fetched.first?.id
            }
        } catch {
            vehicles = []
            errorMessage = error.localizedDescription
        }
    }

    func setSelectedVehicleId(_ id: UUID) {
        selectedVehicleId = id
    }

    var activeVehicle: Vehicle? {
        if let id = selectedVehicleId,
           let v = vehicles.first(where: { $0.id == id }) {
            return v
        }
        return vehicles.first
    }

    func delete(vehicle: Vehicle, session: UserSession) async {
        do {
            try await repo.deleteVehicle(id: vehicle.id, token: session.token)

            vehicles.removeAll { $0.id == vehicle.id }

            // seçili araç silindiyse yeni seç
            if session.selectedVehicleId == vehicle.id {
                let newId = vehicles.first?.id
                session.selectedVehicleId = newId          // UUID?
                // persistSelectedVehicle didSet ile çağrılıyorsa şart değil,
                // ama sende duruyorsa kalsın
                session.persistSelectedVehicle()
                selectedVehicleId = newId
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func delete(at offsets: IndexSet, session: UserSession) async {
        for index in offsets {
            guard vehicles.indices.contains(index) else { continue }
            let v = vehicles[index]
            await delete(vehicle: v, session: session)
        }
    }

    func addVehicle(plateNumber: String, type: VehicleType, session: UserSession) async throws {
        let trimmed = plateNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let created = try await repo.createVehicle(
            CreateVehicleRequest(plateNumber: trimmed, type: type),
            token: session.token
        )

        vehicles.insert(created, at: 0)

        // yeni ekleneni otomatik seç
        session.selectedVehicleId = created.id
        session.persistSelectedVehicle()
        setSelectedVehicleId(created.id)
    }
}
