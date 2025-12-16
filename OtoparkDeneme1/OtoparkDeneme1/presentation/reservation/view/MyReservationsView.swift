//
//  MyReservationsView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 26.11.2025.
//

import SwiftUI

struct MyReservationsView: View {
    @StateObject private var vm = MyReservationsViewModel()
    
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }()
    
    var body: some View {
        ZStack{
            // Arka plan
            LinearGradient(gradient: Gradient(colors: [Color.black, Color(.darkGray)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            NavigationStack {
                Group {
                    if vm.isLoading {
                        ProgressView("Yükleniyor…")
                    } else if let error = vm.errorMessage {
                        VStack(spacing: 8) {
                            Text(error)
                                .foregroundStyle(.red)
                                .foregroundStyle(.white)
                            Button("Tekrar dene") {
                                Task { await vm.load() }
                            }
                        }
                    } else if vm.reservations.isEmpty {
                        Text("Hiç rezervasyonun yok.")
                            .foregroundStyle(.white)
                    } else {
                        List(vm.reservations) { r in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text("Rezervasyon")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    if r.active {
                                        Text("• Aktif")
                                            .font(.subheadline)
                                            .foregroundStyle(.green)
                                    } else {
                                        Text("• Pasif")
                                            .font(.subheadline)
                                            .foregroundStyle(.white)
                                    }
                                }
                                
                                Text("\(dateFormatter.string(from: r.reservedStart))  ➝  \(dateFormatter.string(from: r.reservedEnd))")
                                    .font(.subheadline)
                                    .foregroundStyle(.white)
                                
                                HStack {
                                    Text(String(format: "%.2f ₺", r.totalPrice))
                                        .font(.subheadline)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    if let level = r.currentChargeLevel {
                                        Text("Şarj: %\(level)")
                                            .font(.subheadline)
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                            .padding(.all, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.06))   // koyu gri kart
                            )
                            .listRowBackground(Color.clear)
                        }
                        .scrollContentBackground(.hidden)            // List'in beyaz content background'unu gizle
                        .background(Color.clear)                     // List'in kendisi şeffaf olsun
                    }
                }
                .task {
                    await vm.load()
                }
            }
        }
    }
}

extension UINavigationBar {
    static func makeTitleWhite() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
#Preview {
    MyReservationsView()
}
