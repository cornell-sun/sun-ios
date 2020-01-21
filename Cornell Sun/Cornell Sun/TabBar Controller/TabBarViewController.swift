//
//  TabBarViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 9/4/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

class TabBarViewController: UITabBarController {

    var posts: [ListDiffable]!
    var headlinePost: PostObject?
    var previousViewController: UIViewController?
    var currentViewController: ViewController? {
        let navigationController = viewControllers?.first as? UINavigationController
        return navigationController?.viewControllers.first as? ViewController
    }


    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem?.tintColor = darkModeEnabled ? .white : .black
        // Do any additional setup after loading the view.



//        tabBar.backgroundImage = UIImage()
        let normal = [NSAttributedString.Key.font: UIFont(name: "SanFranciscoText-Medium", size: 11) as Any, NSAttributedString.Key.strokeColor: darkModeEnabled ? UIColor.unselectedDark as Any : UIColor.black70 as Any] as [NSAttributedString.Key: Any]
        let selected = [NSAttributedString.Key.font: UIFont(name: "SanFranciscoText-Semibold", size: 11) as Any, NSAttributedString.Key.strokeColor: darkModeEnabled ? UIColor.white as Any : UIColor.brick as Any] as [NSAttributedString.Key: Any]

        tabBarItem.setTitleTextAttributes(normal, for: .normal)
        tabBarItem.setTitleTextAttributes(selected, for: .selected)
        delegate = self
        setupTabs()

        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .darkModeToggle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideVC(notification:)), name: .darkModeToggle, object: nil)

        updateColors()
    }

    @objc func updateColors() {

        if(darkModeEnabled) {
            view.backgroundColor = .darkTint
            tabBar.backgroundColor = .darkTint
            tabBar.barTintColor = .darkTint
            tabBar.isTranslucent = false
            tabBar.tintColor = .white
            tabBar.unselectedItemTintColor = .unselectedDark
        } else {
            view.backgroundColor = .white
            tabBar.backgroundColor = .white
            tabBar.tintColor = .brick
            tabBar.unselectedItemTintColor = .black70
        }

    }

    @objc func hideVC(notification: NSNotification) {
        if(!darkModeEnabled) {
            if let hidden = notification.userInfo?["hidden"] as? Bool {
                if(hidden) {
                    view.backgroundColor = .darkCell
                } else {
                    view.backgroundColor = .darkCell
                }
            }
        }

    }

    init(with postObjects: [ListDiffable], mainHeadlinePost: PostObject?) {
        posts = postObjects
        headlinePost = mainHeadlinePost
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTabs() {
        // replace each tab with a specified ViewController,
        // these are just placeholders

        var imageChoice: String

        if(darkModeEnabled) {
            imageChoice = "Dark"
        } else {
            imageChoice = "Light"
        }

        let feedVC = FeedCollectionViewController()
        feedVC.feedData = posts
        if let mainHeadlinePost = headlinePost {
            feedVC.headlinePost = mainHeadlinePost
        }
        let tabOneNavigationController = UINavigationController(rootViewController: feedVC)
        tabOneNavigationController.navigationBar.isTranslucent = false
        let tabOneTabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "newsIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "newsIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
        tabOneNavigationController.tabBarItem = tabOneTabBarItem

        let tabTwoNavigationController = UINavigationController(rootViewController: SectionViewController())
        let tabTwoTabBarItem = UITabBarItem(title: "Sections", image: UIImage(named: "sectionIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "sectionIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
        tabTwoNavigationController.tabBarItem = tabTwoTabBarItem

        let tabThreeNavigationController = UINavigationController(rootViewController: BookmarkCollectionViewController())
        let tabThreeTabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(named: "bookmarkIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "bookmarkIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
        tabThreeNavigationController.tabBarItem = tabThreeTabBarItem

        let searchVC = SearchViewController(fetchTrending: true)
        let tabFourNavigationController = UINavigationController(rootViewController: searchVC)
        let tabFourTabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "searchIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "searchIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
        tabFourNavigationController.tabBarItem = tabFourTabBarItem

        let tabFiveNavigationController = UINavigationController(rootViewController: SettingsViewController())
        let tabFiveTabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settingsIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "settingsIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
        tabFiveNavigationController.tabBarItem = tabFiveTabBarItem


        self.viewControllers = [tabOneNavigationController, tabTwoNavigationController, tabThreeNavigationController, tabFourNavigationController, tabFiveNavigationController]
        selectedIndex = 0

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TabBarViewController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // do scroll to top

    }
}
