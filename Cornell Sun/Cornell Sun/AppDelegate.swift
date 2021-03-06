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
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var storyboard: UIStoryboard?
    var isLoadingFromDeeplink: Bool = false
    let redirectScheme = "cornellsun"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        // Set all navigation bar attributes
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().tintColor = .black70

        // Set up OneSignal
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: true]
        let handleNotificationReceivedBlock: OSHandleNotificationReceivedBlock = { _ in }

        let handleNotificationActionBlock: OSHandleNotificationActionBlock = { result in
            guard let result = result, let payloadBody = result.notification.payload.additionalData as? [String: String] else { return }
            if let postValue = payloadBody["id"], let postID = Int(postValue) {
                getDeeplinkedPostWithId(postID, completion: { (posts, mainHeadlinePost, deeplinkedPost) in
                    guard let deeplinkedPost = deeplinkedPost else { return }
                    let tabBarController = TabBarViewController(with: posts, mainHeadlinePost: mainHeadlinePost)
                    self.window?.rootViewController = tabBarController
                    let articleViewController = ArticleStackViewController(post: deeplinkedPost)
                    if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                        navigationController.pushViewController(articleViewController, animated: true)
                    }
                })
            }
        }

        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "c7e28bf2-698c-4a07-b56c-f2077e43c1b4",
                                        handleNotificationReceived: handleNotificationReceivedBlock,
                                        handleNotificationAction: handleNotificationActionBlock,
                                        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification

        syncNotifications()

        if UserDefaults.standard.object(forKey: "darkModeEnabled") == nil {
            UserDefaults.standard.set(false, forKey: "darkModeEnabled")
            darkModeEnabled = false
        } else {
            darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let sbName = darkModeEnabled ? "Launch Screen Dark2" : "Launch Screen"
        storyboard = UIStoryboard(name: sbName, bundle: nil)
        let rootVC = storyboard?.instantiateInitialViewController()
        window?.rootViewController = rootVC

        // Image cache settings
        ImageCache.default.diskStorage.config.sizeLimit = 100 * 1024 * 1024 //100 mb
        ImageCache.default.diskStorage.config.expiration = StorageExpiration.days(4) //4 days until its removed
        
        if !UserDefaults.standard.bool(forKey: hasOnboardedKey) {
            let onboardingViewController = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            if #available(iOS 13.0, *) {
                    onboardingViewController.isModalInPresentation = true
            }
            self.window?.rootViewController?.present(onboardingViewController, animated: false, completion: nil)
        } else {
            prepareInitialPosts { posts, mainHeadlinePost in
                let tabBarController = TabBarViewController(with: posts, mainHeadlinePost: mainHeadlinePost)
                self.window!.rootViewController = tabBarController
                if let currentViewController = tabBarController.currentViewController, self.isLoadingFromDeeplink {
                    currentViewController.startAnimating()
                }
            }
        }

        //Initialize Google Mobile Ads SDKAds
        //@TODO change ad ID from test ad to our specific ID
        //our actual id ca-app-pub-4474706420182946~3782719574
        //fake id ca-app-pub-3940256099942544/2934735716

        // Init Firebase SDK
        FirebaseConfiguration.shared.setLoggerLevel(.min)
//        FirebaseApp.configure()
        
        // Init Google Mobile Ads SDK
        GADMobileAds.sharedInstance().start(completionHandler: nil)

        return true
    }

    func syncNotifications() {

        let allNotificationTypes: [NotificationType] = [
            .breakingNews, .artsAndEntertainment, .dining, .localNews, .multimedia, .opinion, .science, .sports
        ]

        for notificationType in allNotificationTypes {
            let isSubscribed = UserDefaults.standard.bool(forKey: notificationType.rawValue)
            if isSubscribed {
                OneSignal.sendTag(notificationType.rawValue, value: notificationType.rawValue)
            } else {
                OneSignal.deleteTag(notificationType.rawValue)
            }
        }
    }

    /**
     Receive a universal link redirect and handle it properly. Uses Handoff.
     https://developer.apple.com/library/content/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12-SW2
     */

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        isLoadingFromDeeplink = true
        guard let url = userActivity.webpageURL else { return false }
        
        var currentViewController: ViewController?

        // If app is already open
        if let tabBarViewController = self.window?.rootViewController as? TabBarViewController {
            currentViewController = tabBarViewController.currentViewController
        }
        
        var isValidUrl = true

        API.request(target: .urlToID(url: url)) { response in
            guard let tryID = ((try? response?.mapString()) as String??), let idString = tryID, let id = Int(idString), id != 0 else {
                isValidUrl = false
                return }
            if isValidUrl {
                currentViewController?.startAnimating()
                getDeeplinkedPostWithId(id, completion: { (posts, mainHeadlinePost, deeplinkedPost) in
                    guard let deeplinkedPost = deeplinkedPost else { return }
                    let tabBarController = TabBarViewController(with: posts, mainHeadlinePost: mainHeadlinePost)
                    self.window?.rootViewController = tabBarController
                    let articleViewController = ArticleStackViewController(post: deeplinkedPost)
                    currentViewController?.stopAnimating()
                    if let navigationController = tabBarController.selectedViewController as? UINavigationController {
                        navigationController.pushViewController(articleViewController, animated: true)
                    }
                })
            }
        }
        return false//true
    }

    /**
     Handles opening the url separately (eg. opening cornellsun.com in Safari)
     */
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
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
