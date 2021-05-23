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
    var bioTextView: UITextView!
    var emailLabel: UILabel!
    var imageView: UIImageView!
    var nameLabel: UILabel!

    // MARK: Constants
    static let bioTextViewBottomPadding: CGFloat = -10
    static let bioTextViewTopPadding: CGFloat = 15
    static let bottomPadding: CGFloat = 15 // Padding from the bottom of the bio text view to the bottom of the cell
    static let emailLabelTopPadding: CGFloat = 10
    static let imageViewLeadingPadding: CGFloat = 36
    static let imageViewTopPadding: CGFloat = 21
    static let imageViewWidth: CGFloat = 75
    static let nameLabelLeadingPadding: CGFloat = 22
    static let nameLabelTopPadding: CGFloat = 24

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = AuthorDetailCell.imageViewWidth / 2
        imageView.backgroundColor = .black20
        contentView.addSubview(imageView)

        nameLabel = UILabel()
        nameLabel.font = UIFont.avenir24
        nameLabel.numberOfLines = 0
        nameLabel.setLineSpacing(to: 6)
        contentView.addSubview(nameLabel)

        emailLabel = UILabel()
        emailLabel.font = UIFont.avenir16
        emailLabel.numberOfLines = 1
        contentView.addSubview(emailLabel)

        bioTextView = UITextView()
        bioTextView.backgroundColor = .clear
        bioTextView.font = UIFont.avenir16
        bioTextView.textContainer.lineFragmentPadding = 0
        bioTextView.isScrollEnabled = false
        bioTextView.isEditable = false
        contentView.addSubview(bioTextView)

        setupConstraints()
    }

    func setupConstraints() {
        imageView.snp.remakeConstraints { make in
            make.height.width.equalTo(AuthorDetailCell.imageViewWidth)
            make.top.equalToSuperview().offset(AuthorDetailCell.imageViewTopPadding)
            make.leading.equalToSuperview().offset(AuthorDetailCell.imageViewLeadingPadding)
        }

        nameLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(AuthorDetailCell.nameLabelTopPadding)
            make.leading.equalTo(imageView.snp.trailing).offset(AuthorDetailCell.nameLabelLeadingPadding)
            make.trailing.equalToSuperview().inset(AuthorDetailCell.imageViewLeadingPadding)
        }

        if emailLabel.text != "" {
            emailLabel.snp.remakeConstraints { make in
                make.leading.trailing.equalTo(nameLabel)
                make.top.equalTo(nameLabel.snp.bottom).offset(AuthorDetailCell.emailLabelTopPadding)
            }
        } else {
            emailLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.top.equalTo(nameLabel.snp.bottom)
            }
        }

        if bioTextView.text != "" {
            let imageBottom = imageView.frame.maxY
            let emailBottom = emailLabel.frame.maxY
            let lowestView: UIView = max(imageBottom, emailBottom) == imageBottom ? imageView : emailLabel
            bioTextView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(AuthorDetailCell.imageViewLeadingPadding)
                make.top.equalTo(lowestView.snp.bottom).offset(AuthorDetailCell.bioTextViewTopPadding)
            }
        } else {
            bioTextView.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
        }
    }

    func configure(for authorDetail: AuthorDetailObject) {
        contentView.backgroundColor = darkModeEnabled ? .darkCell : .white
        nameLabel.textColor = darkModeEnabled ? .white90 : .black90
        emailLabel.textColor = darkModeEnabled ? .white90 : .black90
        bioTextView.textColor = darkModeEnabled ? .white90 : .black90

        if authorDetail.imageURL != nil {
            imageView.kf.setImage(with: authorDetail.imageURL)
        } else {
            imageView.image = UIImage(named: "profilePictureDefault")
        }
        nameLabel.text = authorDetail.name
        emailLabel.text = authorDetail.email ?? ""
        bioTextView.text = authorDetail.bio ?? ""
        bioTextView.textContainerInset = UIEdgeInsets.zero

        setupConstraints()
    }

    static func getHeight(for authorDetail: AuthorDetailObject, screenWidth: CGFloat) -> CGFloat {
        let labelWidth = screenWidth - (imageViewLeadingPadding + imageViewWidth + nameLabelLeadingPadding + imageViewLeadingPadding)

        var height = nameLabelTopPadding
        height += authorDetail.name.height(withConstrainedWidth: labelWidth, font: UIFont.avenir24)

        if let email = authorDetail.email, email != "" {
            height = emailLabelTopPadding + email.height(withConstrainedWidth: labelWidth, font: UIFont.avenir16)
        }

        let imageBottom: CGFloat = imageViewTopPadding + imageViewWidth

        height = max(imageBottom, height)

        if let bio = authorDetail.bio, bio != "" {
            height += bioTextViewTopPadding
            let bioWidth = screenWidth - (2 * imageViewLeadingPadding)
            height += bio.height(withConstrainedWidth: bioWidth, font: UIFont.avenir16)
        }

        height += authorDetail.bio == nil
            ? bottomPadding
            : bottomPadding * 2
        return height
    }

    private func createLinkImageView(with image: UIImage) -> UIImageView {
        let imageView = UIImageView(frame: .init(x: 0.0, y: 0.0, width: 25.5, height: 18.0))
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
