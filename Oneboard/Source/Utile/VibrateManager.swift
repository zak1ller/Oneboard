//
//  VibrateManager.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/10.
//

import Foundation
import UIKit

final class VibrateManager {
    static func vibrate(feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(feedbackType)
    }
    
    static func changeOrSelectVibrate() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
