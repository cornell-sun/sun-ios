//
//  AuthorDetailCell.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/5/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import IGListKit
import UIKit

class AuthorDetailCell: UICollectionViewCell {

    // MARK: View vars
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var linkStackView: UIStackView!
    var underlineView: UIView!
    var bioTextView: UITextView!

    // MARK: Constants
    let imageViewWidth: CGFloat = 75

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageViewWidth / 2
        imageView.backgroundColor = .black20
        contentView.addSubview(imageView)

        nameLabel = UILabel()
        nameLabel.textColor = .black90
        nameLabel.font = .systemFont(ofSize: 26, weight: .bold)
        nameLabel.numberOfLines = 0
        nameLabel.setLineSpacing(to: 6)
        contentView.addSubview(nameLabel)

        linkStackView = UIStackView()
        linkStackView.alignment = .fill
        linkStackView.axis = .vertical
        linkStackView.distribution = .fill
        linkStackView.spacing = 0
        contentView.addSubview(linkStackView)

        underlineView = UIView()
        underlineView.backgroundColor = .black20
        contentView.addSubview(underlineView)

        bioTextView = UITextView()
        bioTextView.textColor = .black90
        bioTextView.font = UIFont.articleBody.withSize(14)
        bioTextView.textContainer.lineFragmentPadding = 0
        contentView.addSubview(bioTextView)

        setupConstraints()
    }

    func setupConstraints() {
        let imageViewTopPadding: CGFloat = 23
        let imageViewLeadingPadding: CGFloat = 16
        let nameLabelLeadingPadding: CGFloat = 12
        let linkStackViewTopPadding: CGFloat = 5
        let linkStackViewHeight: CGFloat = 56
        let bioTextViewTopPadding: CGFloat = 17
        let bioTextViewBottomPadding: CGFloat = 32

        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(imageViewWidth)
            make.top.equalToSuperview().offset(imageViewTopPadding)
            make.leading.equalToSuperview().offset(imageViewLeadingPadding)
        }

        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(nameLabelLeadingPadding)
            make.trailing.equalToSuperview().inset(imageViewLeadingPadding)
            make.top.equalTo(imageView)
        }

        linkStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(linkStackViewTopPadding)
            make.height.equalTo(linkStackViewHeight)
        }

        underlineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(imageViewLeadingPadding)
            make.top.equalTo(linkStackView.snp.bottom)
            make.height.equalTo(1)
        }

        bioTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(imageViewLeadingPadding)
            make.top.equalTo(underlineView.snp.bottom).offset(bioTextViewTopPadding)
            make.bottom.equalToSuperview().inset(bioTextViewBottomPadding)
        }
    }

    func configure(for authorDetail: AuthorDetailObject) {
        imageView.kf.setImage(with: authorDetail.imageURL)
        nameLabel.text = authorDetail.name
        bioTextView.text = authorDetail.bio
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
