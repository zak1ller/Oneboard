//
//  CopyManager.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/09.
//

import Foundation
import RealmSwift

final class CopyManager {
    
    static func checkIfHave(item copy: Copy, in list: [Copy]) -> Bool {
        var isContain = false
        for value in list {
            if value.id == copy.id {
                isContain = true
            }
        }
        return isContain
    }
    
    static func append(subject: String?, contents: String) -> Copy.ErrorMessage? {
        if let subject = subject {
            if subject.count > Copy.RequiredLength.subjectMaximumLength.rawValue {
                return .tooLongSubject
            }
        }
        
        if contents.isEmpty {
            return .requireTypeContents
        }
        
        let copy = Copy()
        copy.subject = subject
        copy.contents = contents
        copy.id = String.randomString(of: 32)
        copy.createdDate = Date.currentDateString()
        
        var predic = NSPredicate(format: "id == %@", copy.id)
        while try! Realm().objects(Copy.self).filter(predic).count != 0 {
            // Copy 아이디가 중복되지 않을 때까지 반복해서 아이디를 초기화합니다.
            copy.id = String.randomString(of: 12)
            predic = NSPredicate(format: "id == %@", copy.id)
        }
       
        try! Realm().write({
            try! Realm().add(copy)
        })
        return nil
    }
    
    static func changeForceColor(of item: Copy) {
        try! Realm().write({
            if item.isForceColor {
                item.isForceColor = false
            } else {
                item.isForceColor = true
            }
        })
    }
    
    static func edit(from copy: Copy, newSubject: String?, newContents: String) -> Copy.ErrorMessage? {
        if let newSubject = newSubject {
            if newSubject.count > Copy.RequiredLength.subjectMaximumLength.rawValue {
                return .tooLongSubject
            }
        }
        
        if newContents.isEmpty {
            return .requireTypeContents
        }
        
        try! Realm().write({
            copy.subject = newSubject
            copy.contents = newContents
        })
        return nil
    }
    
    static func remove(copy: Copy) {
        try! Realm().write({
            copy.isDeleted = true
        })
    }
    
    static func get() -> Results<Copy> {
        return try! Realm().objects(Copy.self).sorted(byKeyPath: "createdDate", ascending: false).sorted(byKeyPath: "isForceColor", ascending: false).filter("isDeleted = false")
    }
    
    static func search(toText text: String) -> [Copy] {
        var results: [Copy] = []
        
        // 100% 일치 항목 검색
        var predic = NSPredicate(format: "subject = %@", text)
        let perfectResults = try! Realm().objects(Copy.self).filter(predic).filter("isDeleted = false")
        perfectResults.forEach({results.append($0)})
        
        // ~으로 시작하는 항목 검색
        predic = NSPredicate(format: "subject beginswith %@", text)
        let startResults = try! Realm().objects(Copy.self).filter(predic).filter("isDeleted = false")
        startResults.forEach({
            if !checkIfHave(item: $0, in: results) {
                results.append($0)
            }
        })
        
        // 포함 되어 있는 항목 검색
        predic = NSPredicate(format: "subject contains %@", text)
        let containResults = try! Realm().objects(Copy.self).filter(predic).filter("isDeleted = false")
        containResults.forEach({
            if !checkIfHave(item: $0, in: results) {
                results.append($0)
            }
        })
            
        return results
    }
}
