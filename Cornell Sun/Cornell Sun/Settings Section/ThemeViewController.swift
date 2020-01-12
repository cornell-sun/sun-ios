//
//  ThemeViewController.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 11/19/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import UIKit

class ThemeSetting {
    var name: String
    var enabled: Bool
    
    init(name: String, enabled: Bool) {
        self.name = name
        self.enabled = enabled
    }
}

class ThemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    
    var tableView: UITableView!
    var themes: [ThemeSetting] = []
    
    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleCache = prevViewController.title
        prevViewController.title = "Settings"
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prevViewController.title = titleCache
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = darkModeEnabled ? .darkCell : .white
        title = "Theme"
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(ThemeCell.self, forCellReuseIdentifier: "ThemeCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = darkModeEnabled ? .darkCell : .white
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return UITableViewCell()
    }

}
