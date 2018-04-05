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
    
    let appID = "App ID"
    
    let defBackgroundColor = UIColor(red: 248/256, green: 248/256, blue: 248/256, alpha: 1)
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationInformation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = defBackgroundColor
        //Calling hardcoded populator
        if settings.count == 0 {
            testInit()
        }
    
        // Set up table view for settings
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.tableFooterView = UIView()
        tableView.tableFooterView?.backgroundColor = defBackgroundColor
        tableView.backgroundColor = defBackgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setNavigationInformation() {
        navigationItem.title = "The Cornell Daily Sun"
        let navBar = navigationController?.navigationBar
        navBar?.barTintColor = .white
        navBar?.tintColor = .black
        navBar?.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: .mainHeaderSize)!
        ]
    }
    
    //Table View functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerCell: UITableViewCell
        if let dequeueCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") {
            headerCell = dequeueCell
        } else {
            headerCell = UITableViewCell()
        }
        headerCell.contentView.backgroundColor = defBackgroundColor
        let sectionLabel = UILabel()
        headerCell.contentView.addSubview(sectionLabel)
        sectionLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(headerCell.contentView.snp.left).offset(16)
            make.top.equalTo(headerCell.contentView.snp.top).offset(5)
        }
        sectionLabel.text = sections[section]
        return headerCell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        let setting = settings[indexPath.section][indexPath.row]
        cell.textLabel?.text = setting.settingLabel
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.section][indexPath.row]
        print("Herererea")
        if let next = setting.nextController {
            print("aaaadbdd")
                navigationController?.pushViewController(next, animated: true)
        }
         else {
            switch(setting.type) {
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
                    if let url = URL(string: "http://cornellsun.com/2007/03/01/full-masthead-of-the-cornell-daily-sun/") {
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
                default:
                    print("default")
                    break
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
        settings[0].append(SettingObject(label: "Notification", next: notificationViewController, setType: .none))
        settings[0].append(SettingObject(label: "Login", next: nil, setType: .none))
        
        let subscribeViewController = SubscribeViewController()
        subscribeViewController.prevViewController = self
        settings[0].append(SettingObject(label: "Subscribe", next: subscribeViewController,setType: .none))
        
        //Initializing Support settings
        settings.append([])
        let feedBackViewController = ContactViewController()
        feedBackViewController.prevViewController = self
        feedBackViewController.type = .feedback
        settings[1].append(SettingObject(label: "Send App Feedback", next: feedBackViewController, setType: .feedback))
        settings[1].append(SettingObject(label: "Rate on App Store", next: nil, setType: .rate))
        
        //Initializing About settings
        settings.append([])
        let contactViewController = ContactViewController()
        contactViewController.prevViewController = self
        contactViewController.type = .contactus
        settings[2].append(SettingObject(label: "Contact the Sun", next: contactViewController, setType: .contactus))
        
        let dispViewController = DisplayViewController()
        dispViewController.prevViewController = self
        dispViewController.type = .history
        settings[2].append(SettingObject(label: "History", next: dispViewController, setType: .history))
        settings[2].append(SettingObject(label: "The Masthead", next: nil, setType: .masthead))
        
        let teamViewController = DisplayViewController()
        teamViewController.prevViewController = self
        teamViewController.type = .appteam
        settings[2].append(SettingObject(label: "The App Team", next: teamViewController, setType: .appteam))
        settings[2].append(SettingObject(label: "Privacy Policy", next: nil, setType: .privacy))
    }
}
