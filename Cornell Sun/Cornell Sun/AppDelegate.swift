//
//  AppDelegate.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/20/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import Kingfisher
import GoogleMobileAds
import OneSignal
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?
    let redirectScheme = "cornellsun"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true

        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "c7e28bf2-698c-4a07-b56c-f2077e43c1b4",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        storyboard = UIStoryboard(name: "Launch Screen", bundle: nil)
        let rootVC = storyboard?.instantiateInitialViewController()
        window?.rootViewController = rootVC

        //Image cache settings
        ImageCache.default.maxDiskCacheSize = 50 * 1024 * 1024 //50 mb
        ImageCache.default.maxCachePeriodInSecond = 60 * 60 * 24 * 4 //4 days until its removed

        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: hasOnboardedKey) {
            let onboardingViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            self.window?.rootViewController?.present(onboardingViewController, animated: false, completion: nil)
        } else {
          prepareInitialPosts { posts, mainHeadlinePost in
              let tabBarController = TabBarViewController(with: posts, mainHeadlinePost: mainHeadlinePost)
              self.window!.rootViewController = tabBarController

          }
        }
        
        //Initialize Google Mobile Ads SDKAds
        //@TODO change ad ID from test ad to our specific ID
        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544/2934735716")

        return true
    }

    /**
     Receive a universal link redirect and handle it properly. Uses Handoff.
     https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW2
     */
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

        return false
    }

    /**
     Handles opening the url separately (eg. opening cornellsun.com in Safari)
     */
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
