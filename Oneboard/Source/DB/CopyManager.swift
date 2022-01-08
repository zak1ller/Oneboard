//
//  CopyManager.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation
import RealmSwift

class CopyManager {
    static func append(copy: Copy) {
        try! Realm().write({
            try! Realm().add(copy)
        })
    }
    
    static func remove(copy: Copy) {
        try! Realm().write({
            try! Realm().delete(copy)
        })
    }
    
    static func get() -> Results<Copy> {
        return try! Realm().objects(Copy.self).sorted(byKeyPath: "createdDate", ascending: false)
    }
    
    static func search(searchText: String) -> Results<Copy> {
        let predic = NSPredicate(format: "contents CONTAIN %@", searchText)
        return try! Realm().objects(Copy.self).filter(predic).sorted(byKeyPath: "createdDate", ascending: false)
    }
}
