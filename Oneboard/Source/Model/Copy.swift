//
//  Copy.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/08.
//

import Foundation
import RealmSwift

class Copy: Object {
    enum ErrorMessage: String {
        case requireTypeContents = "내용을 입력해주세요."
        case tooLongSubject = "제목은 20자 이내로 입력해주세요."
    }
    
    enum RequiredLength: Int {
        case subjectMaximumLength = 20
    }
    
    @objc dynamic var id: String!
    @objc dynamic var subject: String?
    @objc dynamic var contents: String!
    @objc dynamic var isForceColor = false
    @objc dynamic var createdDate: String!
}
