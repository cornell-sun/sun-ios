//
//  ThemeCell.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 11/19/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {
    
    var label: UILabel!
    var descriptionLabel: UILabel!
    var toggleSwitch: UISwitch!
    let heightLabel: CGFloat = 20
    let heightSec: CGFloat = 31
    let offsetTop: CGFloat = 11.5
    let offsetLeft = 18
    let offsetRight = -18
    let offsetBottom = -4
    
    var darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = darkModeEnabled ? .darkCell : .white
        
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
        label.textColor = darkModeEnabled ? .white90 : .black90
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.height.equalTo(label.intrinsicContentSize.height)
            make.left.equalTo(contentView.snp.left).offset(offsetLeft)
            make.top.equalTo(contentView).offset(offsetTop)
        }
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = darkModeEnabled ? .white40 : .black40
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(descriptionLabel)
        
        toggleSwitch = UISwitch()
        toggleSwitch.onTintColor = darkModeEnabled ? .white40 : .brick
        toggleSwitch.addTarget(self, action: #selector(toggleSwitched), for: .valueChanged)
        contentView.addSubview(toggleSwitch)
        toggleSwitch.snp.makeConstraints { (make) in
            make.height.equalTo(toggleSwitch.intrinsicContentSize.height)
            make.width.equalTo(toggleSwitch.intrinsicContentSize.width)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(offsetRight)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.bottom.lessThanOrEqualToSuperview().offset(offsetBottom)
            make.leading.equalTo(label)
            make.trailing.lessThanOrEqualTo(toggleSwitch.snp.leading).inset(-4)
        }
    }
    
    @objc func toggleSwitched(sender: UISwitch) {
        
    }
    
    func setupCell(labelText: String, descriptionText: String, isToggled: Bool) {
        
        label.text = labelText
        descriptionLabel.text = descriptionText
        toggleSwitch.setOn(isToggled, animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
