//
//  String+Extension.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation

extension String {
    static func randomString(of length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var s = ""
        for _ in 0 ..< length {
            s.append(letters.randomElement()!)
        }
        return s
    }
}
