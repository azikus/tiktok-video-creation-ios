//
//  AppDelegate.swift
//  Boomerang-blog
//
//  Created by Antonio Griparić on 02.03.2023..
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
                
        let rootViewController = UINavigationController(rootViewController: CameraViewController())
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    
        return true
    }
}
