//
//  OnboardingTableViewCell.swift
//  Cornell Sun
//
//  Created by Cameron Hamidi on 11/22/20.
//  Copyright © 2020 cornell.sun. All rights reserved.
//

import SnapKit
import UIKit

class OnboardingTableViewCell: UITableViewCell {

    static let height: CGFloat = 60
    static let identifier = "OnboardingTableViewCell"

    let icon = UIImageView()
    let labelSize: CGFloat = 16
    let separatorBottom = UIView()
    let separatorTop = UIView()
    let subscribeSwitch = UISwitch()
    let subtitleLabel = UILabel()
    let tintView = UIView()
    let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none

        contentView.addSubview(icon)

        titleLabel.font = UIFont.boldSystemFont(ofSize: labelSize)
        titleLabel.textColor = .onboardingTableViewLabel
        titleLabel.textAlignment = .left
        contentView.addSubview(titleLabel)

        subtitleLabel.font = UIFont.systemFont(ofSize: labelSize)
        subtitleLabel.textColor = .onboardingTableViewLabel
        subtitleLabel.textAlignment = .left
        contentView.addSubview(subtitleLabel)

        separatorTop.backgroundColor = .white
        contentView.addSubview(separatorTop)

        separatorBottom.backgroundColor = .white
        separatorBottom.isHidden = true
        contentView.addSubview(separatorBottom)

        tintView.backgroundColor = UIColor.white.withAlphaComponent(0.19)
        contentView.addSubview(tintView)

        subscribeSwitch.onTintColor = .brick
        contentView.addSubview(subscribeSwitch)

        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraints() {
        let iconLeading: CGFloat = 15
        let iconSize: CGFloat = 32
        let subscribeSwitchTrailing: CGFloat = -16
        let subtitleLabelTop: CGFloat = 3
        let titleLabelLeading: CGFloat = 13
        let titleLabelTop: CGFloat = 6

        icon.snp.makeConstraints { make in
            make.height.width.equalTo(iconSize)
            make.leading.equalTo(iconLeading)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(titleLabelLeading)
            make.top.equalToSuperview().offset(titleLabelTop)
        }

        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(subtitleLabelTop)
            make.leading.equalTo(titleLabel.snp.leading)
        }

        subscribeSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(subscribeSwitchTrailing)
            make.centerY.equalToSuperview()
        }

        separatorTop.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        separatorBottom.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }

        tintView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(for section: Sections, isLastRow: Bool = false) {
        var imageName = ""
        switch section {
        case .news:
            titleLabel.text = "News"
            subtitleLabel.text = "Subtitle"
            imageName = "news-sectionLight"
        case .opinion:
            titleLabel.text = "Opinions"
            subtitleLabel.text = "Subtitle"
            imageName = "opinionLight"
        case .sports:
            titleLabel.text = "Sports"
            subtitleLabel.text = "Subtitle"
            imageName = "sportsLight"
        case .arts:
            titleLabel.text = "Arts & Entertainment"
            subtitleLabel.text = "Subtitle"
            imageName = "artsLight"
        case .science:
            titleLabel.text = "Science"
            subtitleLabel.text = "Subtitle"
            imageName = "scienceLight"
        case .dining:
            titleLabel.text = "Dining"
            subtitleLabel.text = "Subtitle"
            imageName = "diningLight"
        case .multimedia:
            titleLabel.text = "Multimedia"
            subtitleLabel.text = "Subtitle"
            imageName = "multimediaLight"
        }
        icon.image = UIImage(named: imageName)
        separatorBottom.isHidden = !isLastRow
    }

}
