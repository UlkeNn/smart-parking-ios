//
//  VehicleCardView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 13.12.2025.
//

import SwiftUI

struct VehicleCardView: View {
    let vehicleVM: MyVehiclesViewModel   //  parametre sırayla
     let vehicle: Vehicle?
     let isLoading: Bool
     var onExploreTap: () -> Void
    
    @EnvironmentObject var session: UserSession
    

    @State private var showAddVehicle = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Seçili aracım")
                    .font(.caption)
                    .foregroundColor(.gray)

                Spacer()

                Button {
                        showAddVehicle = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "pencil")
                            Text("Araç Ekle")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                    }
                    .buttonStyle(.plain)
                }

            if isLoading {
                Text("Yükleniyor...")
                    .foregroundColor(.white.opacity(0.85))
                    .font(.title3.bold())
            } else if let vehicle {
                Text(vehicle.plateNumber)
                    .font(.title3.bold())
                    .foregroundColor(.white)

                Text(vehicle.type.displayName)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                ZStack(alignment: .bottomTrailing) {
                    // İstersen tipe göre farklı görsel koyarsın
                    Image("Porsche2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 340, height: 200)
                        .offset(x: -80)
                        .cornerRadius(20)

                    Button(action: onExploreTap) {
                        HStack(spacing: 4) {
                            Text("Araçlarım")
                            Image(systemName: "chevron.right")
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.12)) // ButtonBGColorOnB varsa onu kullan
                        .cornerRadius(20)
                        .padding(12)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                Text("Araç bulunamadı")
                    .foregroundColor(.white.opacity(0.85))
                    .font(.title3.bold())

                Text("Lütfen araç ekleyin.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
                
        }
        .padding()
        .background(Color.white.opacity(0.08))
        .cornerRadius(20)
        .offset(x: -27)
        .sheet(isPresented: $showAddVehicle) {
                    AddVehicleSheet(vehicleVM: vehicleVM)
                        .environmentObject(session)
                }
    }

}

/*
#Preview {
    VehicleCardView()
}
*/
