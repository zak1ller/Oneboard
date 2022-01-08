//
//  Copy.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/08.
//

import Foundation
import RealmSwift

class Copy: Object {
    @objc dynamic var id: String!
    @objc dynamic var contents: String!
    @objc dynamic var isForceColor = false
    @objc dynamic var createdDate: String!
}
