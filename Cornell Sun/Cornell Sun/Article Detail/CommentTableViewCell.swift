//
//  CommentTableViewCell.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    let profileImageSize = CGSize(width: 36, height: 36)
    let leadingPadding: CGFloat = 18.5
    let topPadding: CGFloat = 14.5
    let nameLabelLeading: CGFloat = 8
    let timeStampTrailing: CGFloat = 17
    let textViewTopOffset: CGFloat = 11
    let textViewBottomInset: CGFloat = 12

    var profileImageView: UIImageView!
    var nameLabel: UILabel!
    var timestampLabel: UILabel!
    var commentTextView: UITextView!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none

        profileImageView = UIImageView(frame: .zero)
        profileImageView.backgroundColor = .black40
        profileImageView.layer.cornerRadius = profileImageSize.width/2
        profileImageView.layer.masksToBounds = true

        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(profileImageSize.height)
            make.top.equalToSuperview().offset(topPadding)
            make.leading.equalToSuperview().offset(leadingPadding)
        }

        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = .subSecondaryHeader
        nameLabel.textColor = .black90
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(nameLabelLeading)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }

        timestampLabel = UILabel()
        timestampLabel.font = .subSecondaryHeader
        timestampLabel.textColor = .black90
        addSubview(timestampLabel)
        timestampLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(timeStampTrailing)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }

        commentTextView = UITextView()
        commentTextView.font = .subSecondaryHeader
        commentTextView.textColor = .black90
        commentTextView.isScrollEnabled = false
        commentTextView.isEditable = false
        commentTextView.autoresizesSubviews = true
        contentView.addSubview(commentTextView)
    }

    func setup(for comment: CommentObject) {
        nameLabel.text = comment.authorName
        timestampLabel.text = comment.date.timeAgoSinceNow()
        commentTextView.text = comment.comment
        profileImageView.kf.setImage(with: comment.profileImageURL)
        commentTextView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(textViewTopOffset)
            make.leading.trailing.equalToSuperview().inset(leadingPadding)
            make.bottom.equalToSuperview().inset(textViewBottomInset)
        }
        setNeedsUpdateConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
