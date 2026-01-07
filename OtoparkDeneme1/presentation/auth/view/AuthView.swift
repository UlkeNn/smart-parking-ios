//
//  AuthView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 19.11.2025.
//

import SwiftUI
struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()
    @EnvironmentObject private var session: UserSession

    @State private var isRegisterMode = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text(isRegisterMode ? "Kayıt Ol" : "Giriş Yap")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)

                    TextField("E-posta", text: $viewModel.email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Şifre", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)

                    if isRegisterMode {
                        TextField("Ad Soyad", text: $viewModel.fullName)
                            .textFieldStyle(.roundedBorder)

                        TextField("İlçe", text: $viewModel.district)
                            .textFieldStyle(.roundedBorder)

                        TextField("İl", text: $viewModel.province)
                            .textFieldStyle(.roundedBorder)
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }

                    Button {
                        Task {
                            if isRegisterMode {
                                await viewModel.register()
                            } else {
                                if let result = await viewModel.login() {
                                    let (token, backendUser) = result
                                    KeychainStorage.save(token: token, email: viewModel.email)

                                    let user = User(from: backendUser)
                                    session.applyLogin(user: user, token: token)
                                }
                            }
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text(isRegisterMode ? "Kayıt Ol" : "Giriş Yap")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading)

                    Button(isRegisterMode ? "Zaten hesabın var mı? Giriş yap" : "Hesabın yok mu? Kayıt ol") {
                        withAnimation {
                            isRegisterMode.toggle()
                        }
                    }
                    .font(.footnote)

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    AuthView()
}
