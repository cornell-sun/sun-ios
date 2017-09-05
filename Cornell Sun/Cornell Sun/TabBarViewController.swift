//
//  TabBarViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 9/4/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import LGSideMenuController

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
        
        let leftMenuOneTableViewController = UITableViewController(style: .plain)
        let tabOneNavigationController = UINavigationController(rootViewController: ViewController())
        let tabOneSideMenuController = LGSideMenuController(rootViewController: tabOneNavigationController,
                                                      leftViewController: leftMenuOneTableViewController,
                                                      rightViewController: nil)
        tabOneSideMenuController.leftViewWidth = 250.0
        tabOneSideMenuController.leftViewPresentationStyle = .slideAbove
        let tabOneTabBarItem = UITabBarItem(title: "News", image: nil, selectedImage: nil)
        tabOneSideMenuController.tabBarItem = tabOneTabBarItem
        
        let leftMenuTwoTableViewController = UITableViewController(style: .plain)
        let tabTwoNavigationController = UINavigationController(rootViewController: ViewController())
        let tabTwoSideMenuController = LGSideMenuController(rootViewController: tabTwoNavigationController,
                                                            leftViewController: leftMenuTwoTableViewController,
                                                            rightViewController: nil)
        tabTwoSideMenuController.leftViewWidth = 250.0
        tabTwoSideMenuController.leftViewPresentationStyle = .slideAbove
        let tabTwoTabBarItem = UITabBarItem(title: "Bookmarks", image: nil, selectedImage: nil)
        tabTwoSideMenuController.tabBarItem = tabTwoTabBarItem
        
        let leftMenuThreeTableViewController = UITableViewController(style: .plain)
        let tabThreeNavigationController = UINavigationController(rootViewController: ViewController())
        let tabThreeSideMenuController = LGSideMenuController(rootViewController: tabThreeNavigationController,
                                                            leftViewController: leftMenuThreeTableViewController,
                                                            rightViewController: nil)
        tabThreeSideMenuController.leftViewWidth = 250.0
        tabThreeSideMenuController.leftViewPresentationStyle = .slideAbove
        let tabThreeTabBarItem = UITabBarItem(title: "Notifications", image: nil, selectedImage: nil)
        tabThreeSideMenuController.tabBarItem = tabThreeTabBarItem

        let leftMenuFourTableViewController = UITableViewController(style: .plain)
        let tabFourNavigationController = UINavigationController(rootViewController: ViewController())
        let tabFourSideMenuController = LGSideMenuController(rootViewController: tabFourNavigationController,
                                                            leftViewController: leftMenuFourTableViewController,
                                                            rightViewController: nil)
        tabFourSideMenuController.leftViewWidth = 250.0
        tabFourSideMenuController.leftViewPresentationStyle = .slideAbove
        let tabFourTabBarItem = UITabBarItem(title: "Settings", image: nil, selectedImage: nil)
        tabFourSideMenuController.tabBarItem = tabFourTabBarItem

        
        viewControllers = [tabOneSideMenuController, tabTwoSideMenuController, tabThreeSideMenuController, tabFourSideMenuController]
        selectedIndex = 0
    }
    
    func setupSideMenuController(rootViewController: UINavigationController) {
        let leftMenuTableViewController = UITableViewController(style: .plain)
        let sideMenuController = LGSideMenuController(rootViewController: rootViewController,
                                                      leftViewController: leftMenuTableViewController,
                                                      rightViewController: nil)
        sideMenuController.leftViewWidth = view.frame.width * 0.8
        sideMenuController.leftViewPresentationStyle = .slideAbove
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
