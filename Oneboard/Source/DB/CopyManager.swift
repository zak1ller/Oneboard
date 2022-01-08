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
    
    static func get(sort: CopyGetSort.GetSortType) -> Results<Copy> {
        switch sort {
        case .none:
            return try! Realm().objects(Copy.self)
        case .asending:
            return try! Realm().objects(Copy.self).sorted(byKeyPath: "createdDate", ascending: true)
        case .desending:
            return try! Realm().objects(Copy.self).sorted(byKeyPath: "createdDate", ascending: false)
        }
        
    }
}
