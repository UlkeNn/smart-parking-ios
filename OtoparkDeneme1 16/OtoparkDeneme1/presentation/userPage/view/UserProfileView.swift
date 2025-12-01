//
//  UserProfileView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 3.11.2025.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject private var session: UserSession

    @State private var fullName: String = ""
    @State private var district: String = ""
    @State private var province: String = ""
    @State private var showingSavedAlert = false

    private var roleText: String {
        switch session.user.role {
        case .basic: return "Temel Kullanıcı"
        case .admin: return "Yönetici"
        case .supervisor: return "Denetçi"
        }
    }

    private func saveChanges() {
        session.user.fullName = fullName
        session.user.district = district
        session.user.province = province
        showingSavedAlert = true
    }

    var body: some View {
        ZStack {
            // ARKA PLAN
            LinearGradient(
                gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack{
                // PROFİL KARTI
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 16) {
                        Image(session.user.avatarImageName ?? "profilFoto")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )

                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.user.fullName)
                                .font(.headline)
                                .foregroundColor(.white)

                            Text(roleText)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)   // 🔥 TAM GENİŞLİK
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.06))
                )
                .padding(.horizontal, 16)      // 🔥 YANDAN GÜZEL MARGIN EKLİYOR
                // Kullanıcı Bilgileri Başlığı
                Text("Kullanıcı Bilgileri")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                // Kutu Container
                VStack(spacing: 12) {

                    // Her bir satır kutu
                    CustomInputBox(title: "Ad Soyad", text: $fullName)
                    CustomInputBox(title: "İlçe", text: $district)
                    CustomInputBox(title: "İl", text: $province)

                }
                .padding(.horizontal)
            }
            
        }
        .navigationTitle("Profilim")
        .onAppear {
            fullName = session.user.fullName
            district = session.user.district
            province = session.user.province
        }
        .alert("Bilgiler Kaydedildi", isPresented: $showingSavedAlert) {
            Button("Tamam", role: .cancel) { }
        }
    }
}
struct CustomInputBox: View {
    let title: String
    @Binding var text: String

    var body: some View {
        TextField(title, text: $text)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.08)) // daha koyu gri
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
            )
            .foregroundColor(.white)
    }
}
