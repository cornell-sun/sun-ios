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

    enum SettingsSections: String {
        case notifications = "Notifications"
        case subscribe = "Subscribe"
        case theme = "Theme"
        case feedback = "Send App Feedback"
        case rate = "Rate on App Store"
        case contact = "Contact the Sun"
        case history = "History"
        case masthead = "The Masthead"
        case appTeam = "The App Team"
        case privacyPolicy = "Privacy Policy"

        func getVc(prevViewController: UIViewController) -> UIViewController? {
            switch self {
            case .notifications:
                var vc = NotificationViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.prevViewController = prevViewController
                return vc
            case .subscribe:
                var vc = SubscribeViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.prevViewController = prevViewController
                return vc
            case .theme:
                var vc = ThemeViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.prevViewController = prevViewController
                return vc
            case .feedback:
                var vc = ContactViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.prevViewController = prevViewController
                vc.settingType = .feedback
                return vc
            case .contact:
                var vc = ContactViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.prevViewController = prevViewController
                vc.settingType = .contactus
                return vc
            case .history:
                var vc = DisplayViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.prevViewController = prevViewController
                vc.type = .history
                return vc
            case .appTeam:
                var vc = TeamViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.prevViewController = prevViewController
                return vc
            default:
                return nil
            }
        }
    }

    var tableView: UITableView!
//    var settings: [[SettingObject]] = []

    let sectionHeaders = ["ACCOUNT", "SUPPORT", "ABOUT"]
    let sections: [[SettingsSections]] = [
        [.notifications, .subscribe, .theme],
        [.feedback, .rate],
        [.contact, .history, .masthead, .appTeam, .privacyPolicy]
    ]

    let appID = "1375063933"
    let headerReuseIdentifier = "HeaderCell"
    let settingReuseIdentifier = "SettingCell"

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.headerTitle
        ]
        
        updateColors()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Calling hardcoded populator
//        if settings.count == 0 {
//            testInit()
//        }
    
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
        
        navigationController?.navigationBar.barTintColor = darkModeEnabled ? .darkTint : .white
        navigationController?.navigationBar.barStyle = darkModeEnabled ? .blackTranslucent : .default
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = darkModeEnabled ? .white : .black
        let titleColor = darkModeEnabled ? UIColor.darkText : UIColor.lightText
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor]
        
        tableView.backgroundColor = darkModeEnabled ? .darkCell : .white
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
        sectionLabel.text = sectionHeaders[section]
        
        headerCell.contentView.backgroundColor = darkModeEnabled ? .darkTableHeader : .black5
        let textColor = darkModeEnabled ? UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1.0) : UIColor(white: 74/255, alpha: 1.0)
        sectionLabel.textColor = textColor
        
        return headerCell.contentView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        let setting = sections[indexPath.section][indexPath.row]
        cell.textLabel?.text = setting.rawValue
        cell.textLabel?.font = .secondaryHeader
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
        if darkModeEnabled {
            cell.backgroundColor = .darkCell
            cell.textLabel?.textColor = .darkText
        } else {
            cell.backgroundColor = .white
            cell.textLabel?.textColor = .black
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = sections[indexPath.section][indexPath.row]

        switch setting {
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
        case .privacyPolicy:
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
                mastheadViewController.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(mastheadViewController, animated: true)
            }
        default:
            guard let sectionVc = setting.getVc(prevViewController: self) else { return }
            navigationController?.pushViewController(sectionVc, animated: true)
        }
    }
}

//        if let next = setting.nextController {
//            print("section: \(indexPath.section)")
//            print("row: \(indexPath.row)")
//            print(settings)
//            navigationController?.pushViewController(next, animated: true)
//        } else {
//            switch setting.type! {
//            case .rate:
//                let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
//                if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
//                    if #available(iOS 10.0, *) {
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                    } else {
//                        UIApplication.shared.openURL(url)
//                    }
//                } else {
//                    let alert = UIAlertController(title: "Error", message: "The app is not available for rating yet", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                    self.present(alert, animated: true)
//                }
//            case .privacy:
//                if let url = URL(string: "http://cornellsun.com/2008/06/01/cornellsun-com-privacy-policy/") {
//                    if #available(iOS 11.0, *) {
//                        let config = SFSafariViewController.Configuration()
//                        config.entersReaderIfAvailable = true
//                        let vc = SFSafariViewController(url: url, configuration: config)
//                        present(vc, animated: true)
//                    } else {
//                        // Fallback on earlier versions
//                        let safariVC = SFSafariViewController(url: url)
//                        self.present(safariVC, animated: true, completion: nil)
//                    }
//                }
//            case .masthead:
//                if let url = URL(string: "http://i1.wp.com/cornellsun.com/wp-content/uploads/2015/10/Screen-Shot-2018-03-07-at-10.10.55-AM.png?w=394") {
//                    let mastheadViewController = MastheadViewController(url: url)
//                    mastheadViewController.hidesBottomBarWhenPushed = true
//                    navigationController?.pushViewController(mastheadViewController, animated: true)
//                }
//            default:
//                print("default")
//            }

    //Populator for settings array
//    func testInit() {
//        //Initializing sections
//
//
//        //Initializing Account settings
//        settings.append([])
//        let notificationViewController = NotificationViewController()
//        notificationViewController.hidesBottomBarWhenPushed = true
//        notificationViewController.prevViewController = self
//        settings[0].append(SettingObject(label: "Notifications", next: notificationViewController, setType: .nonSetting))
//
//        let subscribeViewController = SubscribeViewController()
//        subscribeViewController.hidesBottomBarWhenPushed = true
//        subscribeViewController.prevViewController = self
//        settings[0].append(SettingObject(label: "Subscribe", next: subscribeViewController, setType: .nonSetting))
//
//        let themeViewController = ThemeViewController()
//        themeViewController.hidesBottomBarWhenPushed = true
//        themeViewController.prevViewController = self
//        settings[0].append(SettingObject(label: "Theme", next: themeViewController, setType: .nonSetting))
//
//        //Initializing Support settings
//        settings.append([])
//        let feedBackViewController = ContactViewController()
//        feedBackViewController.hidesBottomBarWhenPushed = true
//        feedBackViewController.prevViewController = self
//        feedBackViewController.settingType = .feedback
//        settings[1].append(SettingObject(label: "Send App Feedback", next: feedBackViewController, setType: .feedback))
//        settings[1].append(SettingObject(label: "Rate on App Store", next: nil, setType: .rate))
//
//        //Initializing About settings
//        settings.append([])
//        let contactViewController = ContactViewController()
//        contactViewController.hidesBottomBarWhenPushed = true
//        contactViewController.prevViewController = self
//        contactViewController.settingType = .contactus
//        settings[2].append(SettingObject(label: "Contact the Sun", next: contactViewController, setType: .contactus))
//
//        let dispViewController = DisplayViewController()
//        dispViewController.hidesBottomBarWhenPushed = true
//        dispViewController.prevViewController = self
//        dispViewController.type = .history
//        settings[2].append(SettingObject(label: "History", next: dispViewController, setType: .history))
//        settings[2].append(SettingObject(label: "The Masthead", next: nil, setType: .masthead))
//
//        let teamViewController = TeamViewController()
//        teamViewController.hidesBottomBarWhenPushed = true
//        teamViewController.prevViewController = self
//        //teamViewController.type = .appteam
//        settings[2].append(SettingObject(label: "The App Team", next: teamViewController, setType: .appteam))
//        settings[2].append(SettingObject(label: "Privacy Policy", next: nil, setType: .privacy))
//    }
//}
