//
//  HapticsManager.swift
//  Spotify
//
//  Created by Ahmed Amin on 10/05/2022.
//

import Foundation
import UIKit


final class HapticsManager {
    static let shared = HapticsManager()

    private init() {}

    public func vibrateForSelection() {
        DispatchQueue.main.async {
            let generator = UISelectionFeedbackGenerator()
            generator.prepare()
            generator.selectionChanged()
        }
    }

    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(type)
        }
    }
}
