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
    let offsetLeft = 18
    let offsetRight = -18
    let offsetBottom = -4
    
    let userDefaults = UserDefaults.standard
    var notificationType: NotificationType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iconImageView = UIImageView()
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(offsetLeft)
            make.centerY.equalToSuperview()
        }

        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = .black90
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(label.intrinsicContentSize.height)
            make.leading.equalTo(iconImageView.snp.trailing).offset(offsetLeft)
            make.top.equalTo(contentView).offset(offsetTop)
        }

        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .black40
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(descriptionLabel)

        let secondSwitch = UISwitch()
        secondSwitch.onTintColor = UIColor.brick
        if let notifType = notificationType {
            secondSwitch.setOn(userDefaults.bool(forKey: notifType.rawValue), animated: false)
        }
        secondSwitch.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
        contentView.addSubview(secondSwitch)
        secondSwitch.snp.makeConstraints { make in
            make.height.equalTo(secondSwitch.intrinsicContentSize.height)
            make.width.equalTo(secondSwitch.intrinsicContentSize.width)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(offsetRight)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview().offset(offsetBottom)
            make.leading.equalTo(label)
            make.trailing.lessThanOrEqualTo(secondSwitch.snp.leading).inset(-4)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(labelText: String, descriptionText: String, icon: UIImage) {
        iconImageView.image = icon
        label.text = labelText
        descriptionLabel.text = descriptionText

        label.snp.updateConstraints { make in
            make.height.equalTo(label.intrinsicContentSize.height)
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
