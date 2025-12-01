//
//  OtoparkDeneme1App.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 20.10.2025.
//

import SwiftUI

@main
struct OtoparkDeneme1App: App {
    @StateObject private var session = UserSession.initial()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .task {
                    // Token varsa, user’ı backend’den geri yükle
                    if session.isLoggedIn && session.user.fullName.isEmpty {
                        await session.restoreUserFromBackend()
                    }
                }
        }
    }
}
