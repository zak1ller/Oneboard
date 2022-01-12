//
//  CustomSnackBar.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/12.
//

import Foundation
import UIKit
import SnackBar_swift

class CustomSnackBar: SnackBar {
    override var style: SnackBarStyle {
        var style = SnackBarStyle()
        style.background = .main
        style.textColor = .background
        style.font = .contents
        return style
    }
}
