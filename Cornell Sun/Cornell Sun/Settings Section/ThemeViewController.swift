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

class ThemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var prevViewController: UIViewController!
    
    var tableView: UITableView!
    var themes: [(String, ThemeType)] = []
    var themesDisplay: [(String, String)] = []
    
    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = darkModeEnabled ? .darkCell : .white
        title = "Theme"
        
        if themes.count == 0 {
            themes = [("Dark Mode", .darkMode)]
            
            themesDisplay = [("Dark Mode", "Something a little easier on the eyes")]
        }
        
        tableView = UITableView(frame: .zero)
        tableView.register(ThemeCell.self, forCellReuseIdentifier: "ThemeCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = darkModeEnabled ? .darkCell : .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as? ThemeCell {
            let isToggled = UserDefaults.standard.bool(forKey: themes[indexPath.row].1.rawValue)
            cell.selectionStyle = .none
            cell.setupCell(labelText: themesDisplay[indexPath.row].0, descriptionText: themesDisplay[indexPath.row].1, isToggled: isToggled)
            cell.backgroundColor = .black
            return cell
        } else {
            return UITableViewCell()
        }
    }

}
