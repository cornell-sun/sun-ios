//
//  TeamTableViewCell.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 5/27/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {
    
    let heightLabel: CGFloat = 20
    let heightSec: CGFloat = 31
    let offsetTop: CGFloat = 11.5
    let offsetLeft: CGFloat = 16
    let offsetRight: CGFloat = -13.5
    let offsetBottom: CGFloat = 3
    
    let userDefaults = UserDefaults.standard
    var notificationType: NotificationType?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(name: String, title: String, origin: String, liner: String, emoji: String) {
        
        let emojiLabel = UILabel()
        contentView.addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.height.equalTo(heightLabel)
            make.left.equalToSuperview().offset(offsetLeft)
            make.top.equalToSuperview().offset(offsetTop)
        }
        emojiLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emojiLabel.text = emoji
        
        let nameLabel = UILabel()
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(heightLabel)
            make.left.equalTo(emojiLabel.snp.right).offset(offsetLeft*0.5)
            make.top.equalTo(emojiLabel)
        }
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.text = name
        
        let titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(heightLabel)
            make.left.equalTo(emojiLabel.snp.right).offset(offsetLeft*0.5)
            make.top.equalTo(nameLabel.snp.bottom).offset(offsetBottom)
        }
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = title
        
        let originLabel = UILabel()
        contentView.addSubview(originLabel)
        originLabel.snp.makeConstraints { make in
            make.height.equalTo(heightLabel)
            make.left.equalTo(emojiLabel.snp.right).offset(offsetLeft*0.5)
            make.top.equalTo(titleLabel.snp.bottom).offset(offsetBottom)
        }
        originLabel.font = UIFont.systemFont(ofSize: 13)
        originLabel.text = origin
        
        let linerLabel = UILabel()
        contentView.addSubview(linerLabel)
        linerLabel.snp.makeConstraints { make in
            make.height.equalTo(heightLabel)
            make.left.equalTo(emojiLabel.snp.right).offset(offsetLeft*0.5)
            make.top.equalTo(originLabel.snp.bottom).offset(offsetBottom)
            make.bottomMargin.equalTo(-5)
        }
        linerLabel.font = UIFont.italicSystemFont(ofSize: 13)
        linerLabel.text = liner
        
    }
}
