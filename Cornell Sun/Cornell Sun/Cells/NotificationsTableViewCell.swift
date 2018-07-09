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
    var descriptionLabel: UILabel!
    var iconImageView: UIImageView!
    let heightLabel: CGFloat = 20
    let heightSec: CGFloat = 31
    let offsetTop: CGFloat = 11.5
    let offsetLeft = 16
    let offsetRight = -13.5
    let offsetBottom = -7
    
    let userDefaults = UserDefaults.standard
    var notificationType: NotificationType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(labelText: String, descriptionText: String, icon: UIImage) {
        
        iconImageView = UIImageView()
        iconImageView.image = icon
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(offsetLeft)
            make.centerY.equalToSuperview()
        }
        
        
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(heightLabel)
            make.left.equalTo(iconImageView.snp.right).offset(offsetLeft)
            make.top.equalTo(contentView).offset(offsetTop)
        }
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = labelText
        
        descriptionLabel = UILabel()
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.height.equalTo(heightLabel*0.95)
            make.left.equalTo(label.snp.left)
            make.bottomMargin.equalTo(-5)
        }
        descriptionLabel.text = descriptionText
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = UIColor(white: 70/255, alpha: 1.0)
        
        
        let secondSwitch = UISwitch()
        secondSwitch.onTintColor = UIColor.brick
        if let notifType = notificationType {
            secondSwitch.setOn(userDefaults.bool(forKey: notifType.rawValue), animated: false)
        }
        secondSwitch.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
        contentView.addSubview(secondSwitch)
        secondSwitch.snp.makeConstraints { make in
            make.height.equalTo(heightSec)
            //make.top.equalToSuperview().offset(offsetTop)
            make.centerY.equalToSuperview()
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
