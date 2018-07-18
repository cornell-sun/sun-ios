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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.tintColor = .brick
        tabBar.unselectedItemTintColor = .black70
        delegate = self
        setupTabs()
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

        let feedVC = FeedCollectionViewController()
        feedVC.feedData = posts
        if let mainHeadlinePost = headlinePost {
            feedVC.headlinePost = mainHeadlinePost
        }
        let tabOneNavigationController = UINavigationController(rootViewController: feedVC)
        tabOneNavigationController.navigationBar.isTranslucent = false
        let tabOneTabBarItem = UITabBarItem(title: "Feed", image: #imageLiteral(resourceName: "feedIcon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "feedIconRed").withRenderingMode(.alwaysOriginal))
        tabOneNavigationController.tabBarItem = tabOneTabBarItem

        let tabTwoNavigationController = UINavigationController(rootViewController: SectionViewController())
        let tabTwoTabBarItem = UITabBarItem(title: "Sections", image: #imageLiteral(resourceName: "sectionIcon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "sectionIconRed").withRenderingMode(.alwaysOriginal))
        tabTwoNavigationController.tabBarItem = tabTwoTabBarItem

        let tabThreeNavigationController = UINavigationController(rootViewController: BookmarkCollectionViewController())
        let tabThreeTabBarItem = UITabBarItem(title: "Bookmarks", image: #imageLiteral(resourceName: "bookmarkIcon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "bookmarkIconRed").withRenderingMode(.alwaysOriginal))
        tabThreeNavigationController.tabBarItem = tabThreeTabBarItem

        let searchVC = SearchViewController(fetchTrending: true)
        let tabFourNavigationController = UINavigationController(rootViewController: searchVC)
        let tabFourTabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "searchIcon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "searchIconRed").withRenderingMode(.alwaysOriginal))
        tabFourNavigationController.tabBarItem = tabFourTabBarItem

        let tabFiveNavigationController = UINavigationController(rootViewController: SettingsViewController())
        let tabFiveTabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "personSettingsIcon").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "personSettingsIconRed").withRenderingMode(.alwaysOriginal))
        tabFiveNavigationController.tabBarItem = tabFiveTabBarItem

        viewControllers = [tabOneNavigationController, tabTwoNavigationController, tabThreeNavigationController, tabFourNavigationController, tabFiveNavigationController]
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
