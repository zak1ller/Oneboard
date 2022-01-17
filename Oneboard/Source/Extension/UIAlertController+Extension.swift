//
//  UIAlertController+Extension.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/17.
//

import Foundation
import UIKit

extension UIAlertController {
    static var actionSheetForiPad: UIAlertController.Style {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .actionSheet
        } else {
            return .alert
        }
    }
}
