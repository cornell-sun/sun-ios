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
    var subscribeSwitch: UISwitch!
    let heightLabel: CGFloat = 20
    let heightSec: CGFloat = 31
    let offsetTop: CGFloat = 11.5
    let offsetLeft = 18
    let offsetRight = -18
    let offsetBottom = -4

    weak var delegate: NotificationsTableViewCellDelegate?
    
    var darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = darkModeEnabled ? .darkCell : .white

        iconImageView = UIImageView()
        contentView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).offset(offsetLeft)
            make.centerY.equalToSuperview()
        }

        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = darkModeEnabled ? .white90 : .black90
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.height.equalTo(label.intrinsicContentSize.height)
            make.leading.equalTo(iconImageView.snp.trailing).offset(offsetLeft)
            make.top.equalTo(contentView).offset(offsetTop)
        }

        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = darkModeEnabled ? .white40 : .black40
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(descriptionLabel)

        subscribeSwitch = UISwitch()
        subscribeSwitch.onTintColor = darkModeEnabled ? .white40 : .brick
        subscribeSwitch.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
        contentView.addSubview(subscribeSwitch)
        subscribeSwitch.snp.makeConstraints { make in
            make.height.equalTo(subscribeSwitch.intrinsicContentSize.height)
            make.width.equalTo(subscribeSwitch.intrinsicContentSize.width)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(offsetRight)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview().offset(offsetBottom)
            make.leading.equalTo(label)
            make.trailing.lessThanOrEqualTo(subscribeSwitch.snp.leading).inset(-4)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCell(labelText: String, descriptionText: String, icon: UIImage, isSubscribed: Bool) {
        iconImageView.image = icon
        label.text = labelText
        descriptionLabel.text = descriptionText
        subscribeSwitch.setOn(isSubscribed, animated: false)
        label.snp.updateConstraints { make in
            make.height.equalTo(label.intrinsicContentSize.height)
        }
    }
    
    @objc func toggleSwitched(sender: UISwitch) {
        delegate?.switchToggled(for: self, isSubscribed: subscribeSwitch.isOn)
    }
}
