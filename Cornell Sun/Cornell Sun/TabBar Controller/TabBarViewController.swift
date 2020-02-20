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
    

    var darkModeEnabled: Bool!
    
    override func viewDidAppear(_ animated: Bool) {
        updateColors()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        navigationItem.backBarButtonItem?.tintColor = darkModeEnabled ? .white : .black
        // Do any additional setup after loading the view.
        
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")


//        tabBar.backgroundImage = UIImage()
        
        delegate = self
        updateColors()
        setupTabs()

        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .darkModeToggle, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideVC(notification:)), name: .darkModeToggle, object: nil)
        
    }

    @objc func updateColors() {
        
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        
        let normal = [NSAttributedString.Key.font: UIFont(name: "SanFranciscoText-Medium", size: 11) as Any, NSAttributedString.Key.strokeColor: darkModeEnabled ? UIColor.unselectedDark as Any : UIColor.black70 as Any] as [NSAttributedString.Key: Any]
        let selected = [NSAttributedString.Key.font: UIFont(name: "SanFranciscoText-Semibold", size: 11) as Any, NSAttributedString.Key.strokeColor: darkModeEnabled ? UIColor.white as Any : UIColor.brick as Any] as [NSAttributedString.Key: Any]
        
        tabBarItem.setTitleTextAttributes(normal, for: .normal)
        tabBarItem.setTitleTextAttributes(selected, for: .selected)
        
        view.backgroundColor = darkModeEnabled ? .darkTint : .white
        tabBar.backgroundColor = darkModeEnabled ? .red : .white
        tabBar.tintColor = darkModeEnabled ? .white : .brick
        tabBar.unselectedItemTintColor = darkModeEnabled ? .unselectedDark : .black70
        tabBar.barTintColor = darkModeEnabled ? .darkTint : .white
        tabBar.isTranslucent = false

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
        // replace each tab with a specified ViewController

        let feedVC = FeedCollectionViewController()
        feedVC.feedData = posts
        if let mainHeadlinePost = headlinePost {
            feedVC.headlinePost = mainHeadlinePost
        }
        let tabOneNavigationController = UINavigationController(rootViewController: feedVC)
        tabOneNavigationController.navigationBar.isTranslucent = false

        let tabTwoNavigationController = UINavigationController(rootViewController: SectionViewController())

        let tabThreeNavigationController = UINavigationController(rootViewController: BookmarkCollectionViewController())

        let searchVC = SearchViewController(fetchTrending: true)
        let tabFourNavigationController = UINavigationController(rootViewController: searchVC)

        let tabFiveNavigationController = UINavigationController(rootViewController: SettingsViewController())

        self.viewControllers = [tabOneNavigationController, tabTwoNavigationController, tabThreeNavigationController, tabFourNavigationController, tabFiveNavigationController]
        selectedIndex = 0
        setupTabIcons()
    }
    
    func setupTabIcons() {
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        if let controllers = viewControllers {
            var imageChoice: String
            imageChoice = darkModeEnabled ? "Dark" : "Light"
            
            for i in 0...controllers.count {
                switch i {
                case 0:
                    controllers[i].tabBarItem = UITabBarItem(title: "Feed", image: UIImage(named: "newsIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "newsIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
                case 1:
                    controllers[i].tabBarItem = UITabBarItem(title: "Sections", image: UIImage(named: "sectionIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "sectionIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
                case 2:
                    controllers[i].tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(named: "bookmarkIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "bookmarkIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
                case 3:
                    controllers[i].tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "searchIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "searchIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
                case 4:
                    controllers[i].tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settingsIcon" + imageChoice)!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "settingsIconSelected" + imageChoice)!.withRenderingMode(.alwaysOriginal))
                default:
                    return
                }
            }
        }
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
