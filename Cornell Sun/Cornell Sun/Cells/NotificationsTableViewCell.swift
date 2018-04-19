//
//  SettingsTableViewCell.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 10/27/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit
import OneSignal

class NotificationsTableViewCell: UITableViewCell {
    var label: UILabel!
    let heightLabel = 20
    let heightSec = 31
    let offsetLeft = 16
    let offsetRight = -13.5
    let offsetBottom = -7
    
    let userDefaults = UserDefaults.standard
    var notificationType: NotificationType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(labelText: String) {
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(heightLabel)
            make.left.equalTo(contentView.snp.left).offset(offsetLeft)
            make.centerY.equalTo(contentView)
        }
        label.text = labelText
        let secondSwitch = UISwitch()
        secondSwitch.onTintColor = UIColor.brick
        if let notifType = settingObj.notificationType {
            secondSwitch.setOn(userDefaults.bool(forKey: notifType.rawValue), animated: false)
        }
        secondSwitch.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
        contentView.addSubview(secondSwitch)
        secondSwitch.snp.makeConstraints { make in
            make.height.equalTo(heightSec)
            make.bottom.equalTo(contentView.snp.bottom).offset(offsetBottom)
            make.right.equalTo(contentView.snp.right).offset(offsetRight)
        }
    }
    
    @objc func toggleSwitched(sender: UISwitch) {
        guard let notifType = notificationType else { return }
        userDefaults.set(sender.isOn, forKey: notifType.rawValue)
        if sender.isOn {
            OneSignal.sendTag(notifType.rawValue, value: notifType.rawValue)
        } else {
            OneSignal.deleteTag(notifType.rawValue)
        }
    }
}

