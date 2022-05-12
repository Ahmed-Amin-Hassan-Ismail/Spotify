//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Ahmed Amin on 13/05/2022.
//

import Foundation


struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
