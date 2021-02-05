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

    static let height: CGFloat = 75
    static let identifier = "OnboardingTableViewCell"

    let icon = UIImageView()
    let labelSize: CGFloat = 16
    let separatorBottom = UIView()
    let separatorTop = UIView()
    let subscribeSwitch = UISwitch()
    let subtitleLabel = UILabel()
    let subtitleLabelSize: CGFloat = 16
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

        subtitleLabel.font = UIFont.systemFont(ofSize: subtitleLabelSize)
        subtitleLabel.textColor = .onboardingTableViewLabel
        subtitleLabel.textAlignment = .left
        subtitleLabel.numberOfLines = 0
        contentView.addSubview(subtitleLabel)

        separatorTop.backgroundColor = .white
        contentView.addSubview(separatorTop)

        separatorBottom.backgroundColor = .white
        separatorBottom.isHidden = true
        contentView.addSubview(separatorBottom)

        tintView.backgroundColor = UIColor.white.withAlphaComponent(0.19)
        contentView.addSubview(tintView)

        subscribeSwitch.onTintColor = .brick
        subscribeSwitch.tintColor = .clear
        subscribeSwitch.layer.borderColor = UIColor.white.cgColor
        subscribeSwitch.layer.borderWidth = 1
        contentView.addSubview(subscribeSwitch)

        setConstraints()

        subscribeSwitch.layer.cornerRadius = subscribeSwitch.bounds.height / 2.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraints() {
        let iconLeading: CGFloat = 15
        let iconSize: CGFloat = 32
        let subscribeSwitchTrailing: CGFloat = -16
        let subscribeSwitchWidth: CGFloat = 51
        let subtitleLabelTop: CGFloat = 3
        let subtitleLabelTrailing: CGFloat = -10
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
            make.trailing.equalTo(subscribeSwitch.snp.leading).offset(subtitleLabelTrailing)
        }

        subscribeSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(subscribeSwitchTrailing)
            make.width.equalTo(subscribeSwitchWidth)
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
            subtitleLabel.text = "News you need to know as it happens"
            imageName = "news-sectionWhite"
        case .opinion:
            titleLabel.text = "Opinions"
            subtitleLabel.text = "Thoughts from your peers"
            imageName = "opinionWhite"
        case .sports:
            titleLabel.text = "Sports"
            subtitleLabel.text = "Recaps, features, and more about the Red"
            imageName = "sportsWhite"
        case .arts:
            titleLabel.text = "Arts & Entertainment"
            subtitleLabel.text = "Music, movies, fashion, and performance"
            imageName = "artsWhite"
        case .science:
            titleLabel.text = "Science"
            subtitleLabel.text = "What you need to know about research"
            imageName = "scienceWhite"
        case .dining:
            titleLabel.text = "Dining"
            subtitleLabel.text = "All the food news on campus and in Ithaca"
            imageName = "diningWhite"
        case .multimedia:
            titleLabel.text = "Multimedia"
            subtitleLabel.text = "Photos, videos, and interviews about the Cornell community"
            imageName = "multimediaWhite"
        }
        icon.image = UIImage(named: imageName)
        separatorBottom.isHidden = !isLastRow
    }

}
