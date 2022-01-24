//
//  SceneDelegate.swift
//  Oneboard
//
//  Created by Min-Su Kim on 2022/01/08.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "TABBAR_TITLE_LIST".localized, image: UIImage(systemName: "list.bullet.circle"), selectedImage: nil)
        
        let clipboardViewController = ClipboardViewController()
        clipboardViewController.tabBarItem = UITabBarItem(title: "TABBAR_TITLE_CLIPBOARD".localized, image: UIImage(systemName: "paperclip.circle"), selectedImage: nil)
        
        let tabBarController = CustomTabBarController()
        tabBarController.viewControllers = [mainViewController, clipboardViewController]
        tabBarController.tabBar.tintColor = .darkText
        tabBarController.tabBar.backgroundColor = .background
        tabBarController.delegate = self
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        ClipboardManager.append()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        VibrateManager.changeOrSelectVibrate()
    }
}

