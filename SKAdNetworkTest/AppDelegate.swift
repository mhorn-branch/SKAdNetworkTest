//
//  AppDelegate.swift
//  SKAdNetworkTest
//
//  Created by Michael Horn on 9/13/20.
//

import UIKit
import StoreKit
import AppTrackingTransparency
import AdSupport
import Branch

// Info.plist SkAdNetworkIdentifier: Contact the ad network to learn their ad network identifier. Include this key, and the value of the ad network identifier as a string, as a dictionary in the SKAdNetworkItems key.


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // In the SKAdNetwork Config section of the Branch dashboard, select the YES radio button to have the Branch SDK handle all calls to SKAdNetwork.
        
        // Do NOT opt-in if you decide to:
        
        // 1. Integrate directly with SKAdNetwork and call the SKAdNetwork functions natively.
        // 2.Use another 3rd party library to handle your app's interactions with SKAdNetwork.
        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
            // do stuff with deep link data (nav to page, display content, etc)
            print(params as? [String: AnyObject] ?? {})
        }
        
        // SKAdNetwork Integration Bare Bones - Without Branch SDK
        // Call registerAppForAdNetworkAttribution to generate an Install Notification. This notification is cryptographically signed data from Apple, which validates that a user installed and launched this app as a resut of an ad.
        
        // From here, one of 2 things will happen:
        // 1) Either the conversion value will be updated when the User completes another action OR
        // 2) Timer will expire and a postback will be sent
        SKAdNetwork.registerAppForAdNetworkAttribution()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Branch.getInstance().application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        return Branch.getInstance().continue(userActivity)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // handler for Push Notifications
        Branch.getInstance().handlePushNotification(userInfo)
    }
    
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

