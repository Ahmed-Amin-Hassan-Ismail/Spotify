//
//  SettingModel.swift
//  Spotify
//
//  Created by Ahmed Amin on 12/05/2022.
//

import Foundation


struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
