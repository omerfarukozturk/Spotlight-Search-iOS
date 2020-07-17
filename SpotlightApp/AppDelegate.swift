//
//  AppDelegate.swift
//  SpotlightApp
//
//  Created by Ömer Faruk Öztürk on 1.12.2017.
//  Copyright © 2017 omerfarukozturk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SpotlightManager.sharedInstance.reloadInitialItems()
        return true
    }

}

//MARK: - Spotlight Search
extension AppDelegate {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // Called when Spotlight item tapped. Do anything with specified data.
        SpotlightManager.sharedInstance.spotlightItemTapAction(userActivity)
        return true
    }
}

