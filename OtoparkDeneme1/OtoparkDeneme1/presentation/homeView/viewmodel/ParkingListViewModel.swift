//
//  ParkingListViewModel.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 25.11.2025.
//

import Foundation
import Combine

@MainActor
final class ParkingListViewModel: ObservableObject {
    @Published var parkings: [Parking] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: ParkingRepository
    private let tokenProvider: () -> String?

    init(
        repository: ParkingRepository = DefaultParkingRepository(),
        tokenProvider: @escaping () -> String? = { nil }
    ) {
        self.repository = repository
        self.tokenProvider = tokenProvider
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let token = tokenProvider()
            let list = try await repository.fetchParkings(token: token)
            self.parkings = list
        } catch {
            print("❌ fetchParkings:", error)
            self.errorMessage = "Otoparklar yüklenemedi."
        }
    }
}
