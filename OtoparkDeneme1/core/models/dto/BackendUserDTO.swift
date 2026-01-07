//
//  BackendUserDTO.swift
//  OtoparkDeneme1
//
//  Created by Ulgen on 19.11.2025.
//

import Foundation

struct BackendUserDTO: Codable {
    let email: String
    let fullName: String
    let avatarImageName: String?
    let district: String
    let province: String
    //let role: Role?    // backend rol döndürüyorsa
}
