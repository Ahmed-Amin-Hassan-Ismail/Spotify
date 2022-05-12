//
//  Playlist.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import Foundation


struct Playlist: Codable {
    let description: String
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let name: String
    let owner: User
}
