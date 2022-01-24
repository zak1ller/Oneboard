//
//  CustomTabBarController.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/24.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }
    
    func setupStyle() {
        UITabBar.clearShadow()
        tabBar.layer.applyShadow(color: .gray, alpha: 0.15, x: 0, y: 0, blur: 12)
    }
}
