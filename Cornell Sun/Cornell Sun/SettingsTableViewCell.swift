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
    var secondaryView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupCell(setting: SettingObject) {
        let superview = contentView
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            print(UIFont.labelFontSize)
            make.left.equalTo(superview.snp.left).offset(16)
            make.centerY.equalTo(contentView.center.y)
        }
        label.text = setting.settingLabel
        switch setting.secondaryViewType {
        case SecondaryViewType.Label:
            let secondLabel = UILabel()
            contentView.addSubview(secondLabel)
            secondLabel.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(31)
                make.right.equalTo(superview.snp.right).offset(-13.5)
                make.centerY.equalTo(contentView.center.y)
            }
            secondLabel.text = setting.secondaryLabel
            secondLabel.textAlignment = .right
            secondLabel.font = UIFont(name: "Times New Roman", size: 22)
        case SecondaryViewType.Toggle:
            let secondSwitch = UISwitch()
            contentView.addSubview(secondSwitch)
            secondSwitch.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(31)
                make.bottom.equalTo(superview.snp.bottom).offset(-7)
                make.right.equalTo(superview.snp.right).offset(-14)
            }
            secondaryView = secondSwitch
        default:
            secondaryView = UIView()
            if setting.type == .Clickable {
                self.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
            }
        }
    }
}
