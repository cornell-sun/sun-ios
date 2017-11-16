//
//  SettingsTableViewCell.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 10/27/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

class SettingsTableViewCell: UITableViewCell {
    var label: UILabel!
    let heightLabel = 20
    let heightSec = 31
    let offsetLeft = 16
    let offsetRight = -13.5
    let offsetBottom = -7

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(setting: SettingObject) {
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
}
