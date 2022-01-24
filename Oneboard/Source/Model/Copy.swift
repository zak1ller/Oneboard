//
//  Copy.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/08.
//

import Foundation
import RealmSwift
import IceCream

class Copy: Object {
    
    enum ErrorMessage {
        case requireTypeContents
        case tooLongSubject 
    }
    
    enum RequiredLength: Int {
        case subjectMaximumLength = 20
    }
    
    @objc dynamic var id: String!
    @objc dynamic var subject: String?
    @objc dynamic var contents: String!
    @objc dynamic var isForceColor = false
    @objc dynamic var createdDate: String!
    @objc dynamic var isDeleted = false
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    static func getErrorMessage(_ message: ErrorMessage) -> String {
        var title: String!
        switch message {
        case .tooLongSubject:
            title = "CLIPBOARD_TYPE_SUBJECT_REQUIRE_LESS_THEN_20".localized
        case .requireTypeContents:
            title = "CLIPBOARD_TYPE_CONTENTS_REQUIRE".localized
        }
        return title
    }
}

extension Copy: CKRecordConvertible & CKRecordRecoverable {
    // Leave it blank is all
}
