//
//  Clipboard.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/19.
//

import Foundation
import RealmSwift
import IceCream

class Clipboard: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var contents: String!
    @objc dynamic var createdDate: String!
    @objc dynamic var isDeleted = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Clipboard: CKRecordConvertible & CKRecordRecoverable {
    // Leave it blank is all
}

