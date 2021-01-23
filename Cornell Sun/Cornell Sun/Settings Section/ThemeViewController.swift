//
//  ThemeViewController.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 11/19/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import UIKit
import FirebaseAnalytics

enum ThemeType: String {
    case darkMode = "darkModeEnabled"
}

protocol ThemesCellDelegate: class {
    func switchToggled(for cell: ThemeCell, isEnabled: Bool)
}

class ThemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var prevViewController: UIViewController!
    
    var tableView: UITableView!
    var themes: [(String, ThemeType)] = []
    var themesDisplay: [(String, String)] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        updateColors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        updateColors()
    }
    
    func updateColors() {
        view.backgroundColor = darkModeEnabled ? .darkCell : .white
        navigationController?.navigationBar.barTintColor = darkModeEnabled ? .darkTint : .white
        navigationController?.navigationBar.barStyle = darkModeEnabled ? .blackTranslucent : .default
        navigationController?.navigationBar.tintColor = darkModeEnabled ? .white : .darkTint
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        tableView.backgroundColor = darkModeEnabled ? .darkCell : .white
        tableView.reloadData()
        if let tabBar = navigationController?.tabBarController as? TabBarViewController {
            tabBar.setupTabIcons()
        }
        
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
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let themeType = themes[indexPath.row].1
        
        switch themeType {
        case .darkMode:
            toggleDarkMode(isEnabled: isEnabled)
        }
    }
    
    func toggleDarkMode(isEnabled: Bool) {
        UserDefaults.standard.set(isEnabled, forKey: "darkModeEnabled")
        darkModeEnabled = isEnabled
        updateColors()
        NotificationCenter.default.post(.init(name: .darkModeToggle))
        Analytics.logEvent("Dark_Mode_Toggled", parameters: nil)
    }
}
