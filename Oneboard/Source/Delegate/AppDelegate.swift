//
//  AppDelegate.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/08.
//

import UIKit
import RealmSwift
import Then
import PinLayout
import IceCream
import SnapKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var syncEngine: SyncEngine?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Configuration Realm
    let config = Realm.Configuration(
      schemaVersion: 2,
      migrationBlock: { migration, oldSchemaVersion in })
    Realm.Configuration.defaultConfiguration = config
    
    // Sync realm cloukit
    syncEngine = SyncEngine(objects: [
      SyncObject(type: Copy.self),
      SyncObject(type: Clipboard.self)
    ])
    application.registerForRemoteNotifications()
    
    return true
  }
  
  // MARK: UISceneSession Lifecycle
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }
  
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}

