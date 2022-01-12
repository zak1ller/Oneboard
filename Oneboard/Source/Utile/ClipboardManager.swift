//
//  ClipboardManager.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/11.
//

import Foundation
import UIKit

final class ClipboardManager {
    static func saveToClipboard(text string: String) {
        UIPasteboard.general.string = nil
        UIPasteboard.general.string = string
    }
}
