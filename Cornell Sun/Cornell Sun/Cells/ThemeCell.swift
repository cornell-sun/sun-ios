//
//  ThemeCell.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 11/19/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {
    
    var iconImageView: UIImageView!
    var label: UILabel!
    var descriptionLabel: UILabel!
    var toggleSwitch: UISwitch!
    let heightLabel: CGFloat = 20
    let heightSec: CGFloat = 31
    let offsetTop: CGFloat = 11.5
    let offsetLeft = 18
    let offsetRight = -18
    let offsetBottom = -4

    var icon: String!

    weak var delegate: ThemesCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.height.equalTo(heightLabel)
            make.leading.equalTo(iconImageView.snp.trailing).offset(offsetLeft)
            make.top.equalTo(contentView).offset(2*offsetTop)
        }
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 3
        contentView.addSubview(descriptionLabel)
        
        toggleSwitch = UISwitch()
        toggleSwitch.isOn = darkModeEnabled
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
        
        updateColors()
    }
    
    @objc func toggleSwitched(sender: UISwitch) {
        delegate?.switchToggled(for: self, isEnabled: toggleSwitch.isOn)
        darkModeEnabled = toggleSwitch.isOn
        
        updateColors()
    }
    
    func updateColors() {
        
        contentView.backgroundColor = darkModeEnabled ? .darkCell : .white
        label.textColor = darkModeEnabled ? .white90 : .black90
        descriptionLabel.textColor = darkModeEnabled ? .white40 : .black40
        toggleSwitch.onTintColor = darkModeEnabled ? .white40 : .brick
        
    }
    
    func setupCell(icon: String, labelText: String, descriptionText: String, isToggled: Bool) {
        
        let iconExt = darkModeEnabled ? "Dark" : "Light"
        self.icon = icon
        
        iconImageView.image = UIImage(named: icon + iconExt)
        label.text = labelText
        descriptionLabel.text = descriptionText
        toggleSwitch.setOn(isToggled, animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
