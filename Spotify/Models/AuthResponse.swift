//
//  AuthResponse.swift
//  Spotify
//
//  Created by Ahmed Amin on 11/05/2022.
//

import Foundation


struct AuthResponse: Codable {
    
    let access_token: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String
    let token_type: String
    
}
