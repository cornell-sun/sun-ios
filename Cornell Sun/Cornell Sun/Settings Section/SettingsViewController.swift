//
//  SettingsViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 10/27/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit
import SafariServices

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var sections: [String] = []
    var settings: [[SettingObject]] = []
    
    let appID = "1375063933"
    let headerReuseIdentifier = "HeaderCell"
    let settingReuseIdentifier = "SettingCell"
    
    var darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

    override func viewWillAppear(_ animated: Bool) {
        title = "Settings"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.headerTitle
        ]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        view.backgroundColor = .white
        //Calling hardcoded populator
        if settings.count == 0 {
            testInit()
        }
    
        // Set up table view for settings
        tableView = UITableView()
        tableView.backgroundColor = .black5
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: settingReuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .darkModeToggle, object: nil)
        
        updateColors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateColors() {
        
        if(darkModeEnabled) {
            navigationController?.navigationBar.barTintColor = .darkTint
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
            navigationController?.navigationBar.barStyle = .blackTranslucent
            tableView.backgroundColor = .darkCell
        } else {
            navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightText]
            navigationController?.navigationBar.barStyle = .default
            tableView.backgroundColor = .white
        }
        
        tableView.reloadData()
    }
    
    //Table View functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell: UITableViewCell
        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") {
            headerCell = dequeueCell
        } else {
            headerCell = UITableViewCell()
        }
        let sectionLabel = UILabel()
        headerCell.contentView.addSubview(sectionLabel)
        
        sectionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        sectionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(headerCell.contentView.snp.left).offset(16)
            make.bottom.equalToSuperview().offset(-6)
        }
        sectionLabel.text = sections[section]
        
        if(darkModeEnabled) {
            headerCell.contentView.backgroundColor = .darkTableHeader
            sectionLabel.textColor = UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0)
        } else {
            headerCell.contentView.backgroundColor = .black5
            sectionLabel.textColor = UIColor(white: 74/255, alpha: 1.0)
        }
        
        return headerCell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        let setting = settings[indexPath.section][indexPath.row]
        cell.textLabel?.text = setting.settingLabel
        cell.textLabel?.font = .secondaryHeader
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        if(darkModeEnabled) {
            cell.backgroundColor = .darkCell
            cell.textLabel?.textColor = .darkText
        } else {
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.section][indexPath.row]
        if let next = setting.nextController {
                navigationController?.pushViewController(next, animated: true)
        } else {
            switch setting.type! {
            case .rate:
                let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
                if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                } else {
                    let alert = UIAlertController(title: "Error", message: "The app is not available for rating yet", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true)
            }
            case .privacy:
                if let url = URL(string: "http://cornellsun.com/2008/06/01/cornellsun-com-privacy-policy/") {
                    if #available(iOS 11.0, *) {
                        let config = SFSafariViewController.Configuration()
                        config.entersReaderIfAvailable = true
                        let vc = SFSafariViewController(url: url, configuration: config)
                        present(vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                        let safariVC = SFSafariViewController(url: url)
                        self.present(safariVC, animated: true, completion: nil)
                    }
            }
            case .masthead:
                if let url = URL(string: "http://i1.wp.com/cornellsun.com/wp-content/uploads/2015/10/Screen-Shot-2018-03-07-at-10.10.55-AM.png?w=394") {
                    let mastheadViewController = MastheadViewController(url: url)
                    navigationController?.pushViewController(mastheadViewController, animated: true)
            }
            default:
                print("default")
            }
        }
    }

    //Populator for settings array
    func testInit() {
        //Initializing sections
        sections = ["ACCOUNT", "SUPPORT", "ABOUT"]
        
        //Initializing Account settings
        settings.append([])
        let notificationViewController = NotificationViewController()
        notificationViewController.prevViewController = self
        settings[0].append(SettingObject(label: "Notifications", next: notificationViewController, setType: .nonSetting))
        
        let subscribeViewController = SubscribeViewController()
        subscribeViewController.prevViewController = self
        settings[0].append(SettingObject(label: "Subscribe", next: subscribeViewController, setType: .nonSetting))
        
        let themeViewController = ThemeViewController()
        themeViewController.prevViewController = self
        settings[0].append(SettingObject(label: "Theme", next: themeViewController, setType: .nonSetting))
        
        //Initializing Support settings
        settings.append([])
        let feedBackViewController = ContactViewController()
        feedBackViewController.prevViewController = self
        feedBackViewController.settingType = .feedback
        settings[1].append(SettingObject(label: "Send App Feedback", next: feedBackViewController, setType: .feedback))
        settings[1].append(SettingObject(label: "Rate on App Store", next: nil, setType: .rate))
        
        //Initializing About settings
        settings.append([])
        let contactViewController = ContactViewController()
        contactViewController.prevViewController = self
        contactViewController.settingType = .contactus
        settings[2].append(SettingObject(label: "Contact the Sun", next: contactViewController, setType: .contactus))
        
        let dispViewController = DisplayViewController()
        dispViewController.prevViewController = self
        dispViewController.type = .history
        settings[2].append(SettingObject(label: "History", next: dispViewController, setType: .history))
        settings[2].append(SettingObject(label: "The Masthead", next: nil, setType: .masthead))
        
        let teamViewController = TeamViewController()
        teamViewController.prevViewController = self
        //teamViewController.type = .appteam
        settings[2].append(SettingObject(label: "The App Team", next: teamViewController, setType: .appteam))
        settings[2].append(SettingObject(label: "Privacy Policy", next: nil, setType: .privacy))
    }
}
