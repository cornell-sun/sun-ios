//
//  SkeletonFeedCell.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 4/10/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit
import SkeletonView

class SkeletonFeedCell: UIView {

    let topOffset: CGFloat = 13.5
    let leftOffset: CGFloat = 17
    let imageOffset: CGFloat = 30
    let imageHeight: CGFloat = 305
    let titleHeight: CGFloat = 50
    let labelHeight: CGFloat = 11
    let lineSpace: CGFloat = 3

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        let imageView = UIImageView()
        imageView.isSkeletonable = true
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageHeight)
            make.width.equalTo(frame.width)
            make.top.equalTo(self.snp.top).offset(imageOffset)
        }

        let titleLabel = UILabel()
        titleLabel.isSkeletonable = true
        titleLabel.numberOfLines = 2
        titleLabel.lastLineFillPercent = 40
        titleLabel.font = .articleTitle
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.height.equalTo(titleHeight)
            make.left.equalToSuperview().offset(leftOffset)
            make.width.equalTo(frame.width*0.9)
            make.top.equalTo(imageView.snp.bottom).offset(topOffset)
        }

        let authorLabel = UILabel()
        authorLabel.isSkeletonable = true
        authorLabel.font = .photoCaption
        addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.width.equalTo(frame.width*0.15)
            make.left.equalToSuperview().offset(leftOffset)
            make.top.equalTo(titleLabel.snp.bottom).offset(topOffset)
        }

        /*Using 2 separate labels for content tagline since line spacing cannot be
         adjusted using NSAtrributes in skeleton view */
        let contentLabel = UILabel()
        contentLabel.isSkeletonable = true
        contentLabel.font = .photoCaption
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.width.equalTo(frame.width*0.9)
            make.left.equalToSuperview().offset(leftOffset)
            make.top.equalTo(authorLabel.snp.bottom).offset(topOffset)
        }

        let contentLabel2 = UITextView()
        contentLabel2.isSkeletonable = true
        contentLabel2.font = .photoCaption
        addSubview(contentLabel2)
        contentLabel2.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.width.equalTo(frame.width*0.5)
            make.left.equalToSuperview().offset(leftOffset)
            make.top.equalTo(contentLabel.snp.bottom).offset(lineSpace)
        }

        let timeStampLabel = UILabel()
        timeStampLabel.isSkeletonable = true
        addSubview(timeStampLabel)
        timeStampLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight*0.8)
            make.width.equalTo(frame.width*0.075)
            make.left.equalTo(self.snp.left).offset(leftOffset)
            make.top.equalTo(contentLabel2.snp.bottom).offset(topOffset)
        }
        let buttonLabel = UILabel()
        buttonLabel.isSkeletonable = true
        addSubview(buttonLabel)
        buttonLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight*2)
            make.width.equalTo(frame.width*0.15)
            make.right.equalTo(self.snp.right).inset(leftOffset)
            make.centerY.equalTo(timeStampLabel.snp.centerY)
        }

        let categoryLabel = UILabel()
        categoryLabel.isSkeletonable = true
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.height.equalTo(topOffset)
            make.width.equalTo(frame.width*0.3)
            make.left.equalTo(self.snp.left).offset(leftOffset)
            make.top.equalTo(timeStampLabel.snp.bottom).offset(topOffset*2)
        }

        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray.withAlphaComponent(0.6)
        divider.isSkeletonable = true
        addSubview(divider)
        divider.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.top.equalTo(categoryLabel.snp.bottom).offset(topOffset)
        }

        let secondTitleLabel = UILabel()
        secondTitleLabel.isSkeletonable = true
        secondTitleLabel.numberOfLines = 2
        secondTitleLabel.lastLineFillPercent = 40
        secondTitleLabel.font = .articleTitle
        addSubview(secondTitleLabel)
        secondTitleLabel.snp.makeConstraints { make in
            make.height.equalTo(titleHeight)
            make.left.equalToSuperview().offset(leftOffset)
            make.width.equalTo(frame.width*0.9)
            make.top.equalTo(divider.snp.bottom).offset(topOffset)
        }

        let secondAuthorLabel = UILabel()
        secondAuthorLabel.isSkeletonable = true
        secondAuthorLabel.font = .photoCaption
        addSubview(secondAuthorLabel)
        secondAuthorLabel.snp.makeConstraints { make in
            make.height.equalTo(labelHeight)
            make.width.equalTo(frame.width*0.15)
            make.left.equalToSuperview().offset(leftOffset)
            make.top.equalTo(secondTitleLabel.snp.bottom).offset(topOffset)
        }

        let secondImageView = UIImageView()
        secondImageView.isSkeletonable = true
        addSubview(secondImageView)
        secondImageView.snp.makeConstraints { make in
            make.height.equalTo(imageHeight)
            make.width.equalTo(frame.width)
            make.top.equalTo(secondAuthorLabel.snp.bottom).offset(topOffset)
        }
        
        SkeletonAppearance.default.tintColor = .clouds
        SkeletonAppearance.default.gradient = SkeletonGradient(baseColor: .clouds)
    }

}
