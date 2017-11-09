//
//  SettingsViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 10/27/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var tableView: UITableView!
    var settings: [SettingObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        view.backgroundColor = .white
        //Calling hardcoded test. To be deleted
        if settings.count == 0 {
            testInit()
        }
        // Set up table view for settings
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingsTableViewCell
        let setting = settings[indexPath.row]
        cell.setupCell(setting: setting)
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let setting = settings[indexPath.row]
        if setting.type == SettingType.Clickable {
            if let next = setting.nextController {
                navigationController?.pushViewController(next, animated: true)
            }
        }
    }

    //*Test* populator for settings array. To be deleted
    func testInit() {
        settings.append(SettingObject(label: "Subscribe", secondary: "", next: SettingsViewController(), secType: .None))
        let notifViewController = SettingsViewController()
        let notifSettings = ["Breaking News", "Opinion", "Sports", "Arts and Entertainment", "Science", "Dining", "Multimedia", "Sunspots"]
        for i in notifSettings {
            notifViewController.settings.append(SettingObject(label: i, secondary: "", next: nil, secType: .Toggle))
        }
        settings.append(SettingObject(label: "Notification", secondary: "", next: notifViewController, secType: .None))
        settings.append(SettingObject(label: "Font Size", secondary: "Normal", next: nil, secType: .Label))
        settings.append(SettingObject(label: "Support", secondary: "", next: SettingsViewController(), secType: .None))
        settings.append(SettingObject(label: "Feedback", secondary: "", next: SettingsViewController(), secType: .None))
        settings.append(SettingObject(label: "Rate", secondary: "", next: SettingsViewController(), secType: .None))
        settings.append(SettingObject(label: "About", secondary: "", next: SettingsViewController(), secType: .None))
        settings.append(SettingObject(label: "Privacy Policy", secondary: "", next: SettingsViewController(), secType: .None))
        settings.append(SettingObject(label: "Use Agreement", secondary: "", next: SettingsViewController(), secType: .None))
    }
}
