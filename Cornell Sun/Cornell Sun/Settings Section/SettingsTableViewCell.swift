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

class SettingsTableViewCell: UITableViewCell {
    var label: UILabel!
    let heightLabel = 20
    let heightSec = 31
    let offsetLeft = 16
    let offsetRight = -13.5
    let offsetBottom = -7
    let userDefaults = UserDefaults.standard

    var settingObj: SettingObject!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(setting: SettingObject) {
        settingObj = setting
        let superview = contentView
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(heightLabel)
            make.left.equalTo(superview.snp.left).offset(offsetLeft)
            make.centerY.equalTo(contentView.center.y)
        }
        label.text = setting.settingLabel
        switch setting.secondaryViewType {
        case .label:
            let secondLabel = UILabel()
            contentView.addSubview(secondLabel)
            secondLabel.snp.makeConstraints { make in
                make.height.equalTo(heightSec)
                make.right.equalTo(superview.snp.right).offset(offsetRight)
                make.centerY.equalTo(contentView.center.y)
            }
            secondLabel.text = setting.secondaryLabel
            secondLabel.textAlignment = .right
            secondLabel.font = UIFont(name: "Times New Roman", size: 22) // may be changed
        case .toggle:
            let secondSwitch = UISwitch()
            if let notifType = settingObj.notificationType {
                secondSwitch.setOn(userDefaults.bool(forKey: notifType.rawValue), animated: false)
            }
            secondSwitch.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
            contentView.addSubview(secondSwitch)
            secondSwitch.snp.makeConstraints { make in
                make.height.equalTo(heightSec)
                make.bottom.equalTo(superview.snp.bottom).offset(offsetBottom)
                make.right.equalTo(superview.snp.right).offset(offsetRight)
            }
        default:
            self.accessoryType = .disclosureIndicator
        }
    }

    @objc func toggleSwitched(sender: UISwitch) {
        guard let notifType = settingObj.notificationType else { return }
        userDefaults.set(sender.isOn, forKey: notifType.rawValue)
        if sender.isOn {
            OneSignal.sendTag(notifType.rawValue, value: notifType.rawValue)
        } else {
            OneSignal.deleteTag(notifType.rawValue)
        }
    }
}
