//
//  AudioTrack.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import Foundation


struct AudioTrack: Codable {
    var album: Album?
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let external_urls: [String: String]
    let id: String
    let name: String
    let preview_url: String?
}
