//
//  RootView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 20.10.2025.
//

import SwiftUI

struct RootView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @EnvironmentObject private var session: UserSession

    @Namespace private var animation

    var body: some View {
        ZStack {
            if !hasSeenOnboarding {
                // 1) İlk açılış: Onboarding
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)

            } else if !session.isLoggedIn {
                // 2) Onboarding bitti ama login yok: Auth ekranı
                AuthView()
                    .transition(.opacity)

            } else {
                // 3) Hem onboarding görülmüş hem login olunmuş: ana uygulama
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: hasSeenOnboarding)
        .animation(.easeInOut(duration: 0.5), value: session.isLoggedIn)
    }
}
