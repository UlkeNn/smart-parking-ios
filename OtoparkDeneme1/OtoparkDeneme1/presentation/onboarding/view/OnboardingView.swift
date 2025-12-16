//
//  ContentView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 20.10.2025.
//
import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let imageName: String
}

private let onboardingPages: [OnboardingPage] = [
    .init(title: "Kolay Park", description: "Boş alanları anında gör.", imageName: "ParkPlace"),
    .init(title: "Akıllı Sensörler", description: "Ultrasonik sensörlerle anlık takip.", imageName: "Cloud"),
    .init(title: "QR ile Giriş", description: "Uygulamadaki QR kodla hızlı giriş.", imageName: "PhoneImg")
]

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool     //  RootView’tan Binding geliyor
    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(Array(onboardingPages.enumerated()), id: \.offset) { index, page in
                    VStack(spacing: 24) {
                        Image(page.imageName)          // kendi görsellerin
                            .resizable()
                            .scaledToFit()
                            .frame(height: 400)
                            .padding(.top, 60)

                        Text(page.title)
                            .font(.title.bold())

                        Text(page.description)
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 40)

                        Spacer()
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

            // UIKit tarzı noktalar
            HStack(spacing: 8) {
                ForEach(0..<onboardingPages.count, id: \.self) { i in
                    Circle()
                        .fill(i == currentPage ? Color.primary : Color.secondary.opacity(0.3))
                        .frame(width: i == currentPage ? 10 : 8, height: i == currentPage ? 10 : 8)
                        .animation(.spring(response: 0.3), value: currentPage)
                }
            }
            .padding(.bottom, 20)

            Button {
                if currentPage < onboardingPages.count - 1 {
                    withAnimation { currentPage += 1 }
                } else {
                    withAnimation { hasSeenOnboarding = true } // ✅ HomeView’a geçer
                }
            } label: {
                Text(currentPage == onboardingPages.count - 1 ? "Başla" : "Devam Et")
                    .font(.headline)
                    .foregroundColor(Color("TextColorOnB")) // burada kendi rengini kullanabilirsin
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("ButtonBGColorOnB"))
                    .cornerRadius(20)
                    .padding(.horizontal, 40)
            }
            .padding(.bottom, 40)
        }
        .background(Color("BGColor"))
        .ignoresSafeArea()
    }
}

#Preview {
    //  Preview’da Binding olmadığı için .constant kullan
    OnboardingView(hasSeenOnboarding: .constant(false))
}
