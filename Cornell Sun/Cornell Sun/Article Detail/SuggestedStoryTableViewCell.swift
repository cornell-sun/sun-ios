//
//  SuggestedStoryTableViewCell.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 5/4/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class SuggestedStoryTableViewCell: UITableViewCell {
    let padding: CGFloat = 18
    let articleLeadingOffset: CGFloat = 12
    let imageWidthHeight: CGFloat = 100
    let bylineTopOffset: CGFloat = 8

    var storyImageView: UIImageView!
    var headlineLabel: UILabel!
    var bylineLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none

        storyImageView = UIImageView()
        storyImageView.contentMode = .scaleAspectFill
        storyImageView.clipsToBounds = true
        contentView.addSubview(storyImageView)

        storyImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(padding)
            make.width.height.equalTo(imageWidthHeight)
        }

        headlineLabel = UILabel()
        headlineLabel.numberOfLines = 3
        headlineLabel.font = .articleTitle
        contentView.addSubview(headlineLabel)

        headlineLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(padding)
            make.leading.equalTo(storyImageView.snp.trailing).offset(articleLeadingOffset)
            make.trailing.equalToSuperview().inset(padding)
        }

        bylineLabel = UILabel()
        bylineLabel.font = .cellInformationText
        contentView.addSubview(bylineLabel)

        bylineLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(headlineLabel)
            make.top.equalTo(headlineLabel.snp.bottom).offset(bylineTopOffset)
        }

        setupColors()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupColors() {
        backgroundColor = darkModeEnabled ? .darkCell : .white
        headlineLabel.textColor = darkModeEnabled ? .white90 : .black90
        bylineLabel.textColor = darkModeEnabled ? .white60 : .black60
    }

    func setup(for suggestedStory: SuggestedStoryObject) {
        if let url = suggestedStory.featuredMediaImages?.mediumLarge?.url {
            storyImageView.kf.setImage(with: url)
        } else {
            storyImageView.snp.updateConstraints { make in
                make.width.height.equalTo(0)
            }

            headlineLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().offset(padding)
                make.top.equalToSuperview().offset(padding)
                make.trailing.equalToSuperview().inset(padding)
            }
        }
        headlineLabel.text = suggestedStory.title
        headlineLabel.setLineSpacing(to: 4.5)
        if let byline = suggestedStory.authors?.byline {
            bylineLabel.text = "By \(byline)".uppercased()
        }

        setupColors()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        storyImageView.snp.remakeConstraints { make in
            make.leading.top.equalToSuperview().offset(padding)
            make.width.height.equalTo(imageWidthHeight)
        }

        headlineLabel.snp.remakeConstraints { make in
            make.leading.equalTo(storyImageView.snp.trailing).offset(articleLeadingOffset)
            make.top.equalToSuperview().offset(padding)
            make.trailing.equalToSuperview().inset(padding)
        }

        setupColors()
    }

}
