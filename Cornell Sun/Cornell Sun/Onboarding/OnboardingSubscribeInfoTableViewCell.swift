//
//  OnboardingSubscribeInfoTableViewCell.swift
//  Cornell Sun
//
//  Created by Cameron Hamidi on 12/7/20.
//  Copyright © 2020 cornell.sun. All rights reserved.
//

import SnapKit
import UIKit

enum OnboardingSubscribeSections {

    case firstName
    case lastName
    case email

    static func getSections() -> [OnboardingSubscribeSections] {
        return [.firstName, .lastName, .email]
    }

}

class OnboardingSubscribeInfoTableViewCell: UITableViewCell {

    static let height: CGFloat = 65
    static let identifier = "OnboardingSubscribeInfoTableViewCell"

    let bottomDivider = UIView()
    let textField = UITextField()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        contentView.backgroundColor = .clear

        textField.font = .systemFont(ofSize: 18)
        textField.textColor = .white
        contentView.addSubview(textField)

        bottomDivider.backgroundColor = .white
        contentView.addSubview(bottomDivider)

        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for section: OnboardingSubscribeSections) {
        var placeholderString = ""
        switch section {
        case .firstName:
            placeholderString = "First Name"
        case .lastName:
            placeholderString = "Last Name"
        case .email:
            placeholderString = "Email"
        }
        textField.attributedPlaceholder = NSAttributedString(string: placeholderString,
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    func setConstraints() {
        let bottomDividerHeight: CGFloat = 2
        let textFieldBottom: CGFloat = -9

        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomDivider.snp.top).offset(textFieldBottom)
        }

        bottomDivider.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(bottomDividerHeight)
        }
    }

}
