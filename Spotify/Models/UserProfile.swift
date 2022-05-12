//
//  UserProfile.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import Foundation

struct UserProfile: Codable {
    let country: String
    let display_name: String
    let explicit_content: [String: Bool]
    let external_urls: [String: String]
    let href: String
    let id: String
    let images: [APIImage]
    let product: String
    let type: String
    let uri: String
}
