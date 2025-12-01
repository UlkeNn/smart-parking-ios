//
//  LeadingToolbarView.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 29.10.2025.
//

import SwiftUI

struct LeadingToolbarView: View {
    @EnvironmentObject private var session: UserSession
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action : onTap){
        HStack(spacing: 10) {
            if let imageName = session.user.avatarImageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1))
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(greetingText)
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(session.user.fullName)
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var greetingText: String {
        switch session.user.role {
        case .basic:      return "Hoşgeldin"
        case .admin:      return "Admin panel"
        case .supervisor: return "Supervisor"
        }
    }
}
#Preview {
    LeadingToolbarView()
        .environmentObject(UserSession.mock())
}
