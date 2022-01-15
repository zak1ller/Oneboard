//
//  UIImiageVIew+Extension.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/16.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
