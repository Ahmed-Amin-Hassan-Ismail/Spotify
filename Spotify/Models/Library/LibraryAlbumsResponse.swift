//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Ahmed Amin on 28/05/2022.
//

import Foundation


struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
