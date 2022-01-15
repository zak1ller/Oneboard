//
//  UIColor+Extension.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/08.
//

import Foundation
import UIKit

extension UIColor {
    static let background = UIColor.white
    static let subBackground = UIColor.hexStringToUIColor(hex: "#F0F0F0")
    static let buttonSub = UIColor.hexStringToUIColor(hex: "#e3e3e3")
    static let main = UIColor.black
    static let divider = UIColor.hexStringToUIColor(hex: "#000000").withAlphaComponent(0.12)
    static let special = hexStringToUIColor(hex: "#ed8a19")
    
    static func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
