//
//  ClipboardManager.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/11.
//

import Foundation
import UIKit
import RealmSwift

final class ClipboardManager {
  
  static func append() {
    guard let pasteString = UIPasteboard.general.string else { return }
    UIPasteboard.general.strings = nil
    
    if pasteString.isEmpty {
      return
    }
    
    let clipboard = Clipboard()
    clipboard.id = String.randomString(of: 32)
    clipboard.contents = pasteString
    clipboard.createdDate = Date.currentDateString()
    
    var predic = NSPredicate(format: "id == %@", clipboard.id)
    while try! Realm().objects(Clipboard.self).filter(predic).count != 0 {
      // Copy 아이디가 중복되지 않을 때까지 반복해서 아이디를 초기화합니다.
      clipboard.id = String.randomString(of: 12)
      predic = NSPredicate(format: "id == %@", clipboard.id)
    }
    
    if !isExist(clipboard) {
      try! Realm().write{
        try! Realm().add(clipboard)
      }
    }
  }
  
  static func remove(_ clipboard: Clipboard) {
    try! Realm().write{
      clipboard.isDeleted = true
    }
  }
  
  static func removeAll() {
    try! Realm().write{
      getList().forEach{
        $0.isDeleted = true
      }
    }
  }
  
  static func getList() -> Results<Clipboard> {
    return try! Realm().objects(Clipboard.self).sorted(byKeyPath: "createdDate", ascending: false).filter("isDeleted = false")
  }
  
  static func isExist(_ clipboard: Clipboard) -> Bool {
    let predic = NSPredicate(format: "contents = %@", clipboard.contents)
    let clipboards = try! Realm().objects(Clipboard.self).filter(predic)
    if clipboards.count == 0 {
      return false
    } else {
      return true
    }
  }
  
  static func saveToClipboard(text string: String) {
//    UIPasteboard.general.string = nil
    UIPasteboard.general.string = string
  }
}
