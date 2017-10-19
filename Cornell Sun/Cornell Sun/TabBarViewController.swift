//
//  TabBarViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 9/4/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        tabBar.backgroundImage = UIImage()
        tabBar.tintColor = .black
        delegate = self
        setupTabs()
    }

    func setupTabs() {
        // replace each tab with a specified ViewController,
        // these are just placeholders

        let tabOneNavigationController = UINavigationController(rootViewController: FeedCollectionViewController())
        let tabOneTabBarItem = UITabBarItem(title: "News", image: nil, selectedImage: nil)
        tabOneNavigationController.tabBarItem = tabOneTabBarItem

        let tabTwoNavigationController = UINavigationController(rootViewController: ViewController())
        let tabTwoTabBarItem = UITabBarItem(title: "Sections", image: nil, selectedImage: nil)
        tabTwoNavigationController.tabBarItem = tabTwoTabBarItem

        let tabThreeNavigationController = UINavigationController(rootViewController: ViewController())
        let tabThreeTabBarItem = UITabBarItem(title: "Bookmarks", image: nil, selectedImage: nil)
        tabThreeNavigationController.tabBarItem = tabThreeTabBarItem

        let tabFourNavigationController = UINavigationController(rootViewController: ViewController())
        let tabFourTabBarItem = UITabBarItem(title: "Search", image: nil, selectedImage: nil)
        tabFourNavigationController.tabBarItem = tabFourTabBarItem

        let tabFiveNavigationController = UINavigationController(rootViewController: ViewController())
        let tabFiveTabBarItem = UITabBarItem(title: "Settings", image: nil, selectedImage: nil)
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
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    }
}
