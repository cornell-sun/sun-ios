//
//  ThemeViewController.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 11/19/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import UIKit

enum ThemeType: String {
    case darkMode = "darkModeEnabled"
}

protocol ThemesCellDelegate: class {
    func switchToggled(for cell: ThemeCell, isEnabled: Bool)
}

class ThemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    
    var tableView: UITableView!
    var themes: [(String, ThemeType)] = []
    var themesDisplay: [(String, String)] = []
    
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
    
        title = "Theme"
        
        if themes.count == 0 {
            themes = [("Dark Mode", .darkMode)]
            
            themesDisplay = [("Something a little easier on the eyes", "moon")]
        }
        
        tableView = UITableView(frame: .zero)
        tableView.register(ThemeCell.self, forCellReuseIdentifier: "ThemeCell")
        tableView.tableFooterView = UIView()
//        tableView.backgroundColor = darkModeEnabled ? .darkCell : .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        updateColors(darkMode: darkModeEnabled)
    }
    
    func updateColors(darkMode: Bool) {
        
        view.backgroundColor = darkMode ? .darkCell : .white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = darkMode ? .white : .black
        tableView.backgroundColor = darkMode ? .darkCell : .white
        tableView.reloadData()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as? ThemeCell {
            let isToggled = UserDefaults.standard.bool(forKey: themes[indexPath.row].1.rawValue)
            cell.delegate = self
            cell.selectionStyle = .none
            cell.icon = themesDisplay[indexPath.row].1
            cell.setupCell(icon: themesDisplay[indexPath.row].1, labelText: themes[indexPath.row].0, descriptionText: themesDisplay[indexPath.row].0, isToggled: isToggled)
//            cell.backgroundColor = .black
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

// MARK: - NotificationTableViewCellDelegate
extension ThemeViewController: ThemesCellDelegate {
    func switchToggled(for cell: ThemeCell, isEnabled: Bool) {
        // TO DO
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let themeType = themes[indexPath.row].1
        
        switch themeType {
        case .darkMode:
            toggleDarkMode(isEnabled: isEnabled)
        }
    }
    
    func toggleDarkMode(isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: "darkModeEnabled")
        updateColors(darkMode: isEnabled)
        NotificationCenter.default.post(.init(name: .darkModeToggle))
    }
}
