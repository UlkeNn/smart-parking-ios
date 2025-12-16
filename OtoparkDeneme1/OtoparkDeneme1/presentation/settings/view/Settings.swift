//
//  Settings.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 23.10.2025.
//

import SwiftUI

struct Settings: View {
    
    var body: some View {
        ZStack {
            // Arka plan
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                
                // Başlık
                VStack(spacing: 8) {
                    Text("ChatGPT")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text("Unlimited chat with GPT for only.\nTry It Now")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                
                // Planlar
                VStack(spacing: 16) {
                    PlanView(title: "Weekly Plan", price: "$3.99 USD / Week")
                    PlanView(title: "Monthly Plan", price: "$9.99 USD / Month")
                    PlanView(title: "Annual Plan", price: "$19.99 USD / Year")
                }
                
                Spacer()
                
                // Abone ol butonu
                Button(action: {
                    print("Subscribe tapped")
                }) {
                    Text("Subscribe")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 40)
            }
            .padding(.top, 80)
            .padding(.bottom, 40)
        }
    }}

#Preview {
    Settings()
}

struct PlanView: View {
    var title: String
    var price: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            Text(price)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.black.opacity(0.8))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .cornerRadius(10)
        .padding(.horizontal, 30)
    }
}
