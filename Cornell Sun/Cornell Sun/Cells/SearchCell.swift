//
//  SearchCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 2/4/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

final class SearchCell: UICollectionViewCell {

    let insetConstant: CGFloat = 18
    let offsetConstant: CGFloat = 12
    let imageViewWidthHeight: CGFloat = 90
    let timeLabelOffset: CGFloat = -8
    
    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

    var post: PostObject? {
        didSet {
            if let post = post {
            authorLabel.text = post.author?.byline
            timeStampLabel.text = post.date.timeAgoSinceNow()
            contentLabel.text = post.content.htmlToString.replacingOccurrences(of: "\n", with: "")
            setupImage()
            }
        }
    }

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .photoCaption
        return label
    }()

    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .photoCaption
        return label
    }()

    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = .photoCaption
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.backgroundColor = darkModeEnabled ? .darkCell : .white
        authorLabel.textColor = darkModeEnabled ? .white90 : .black
        timeStampLabel.textColor = darkModeEnabled ? .white60 : .black
        contentLabel.textColor = darkModeEnabled ? .white90 : .black
        addSubview(imageView)
        addSubview(authorLabel)
        addSubview(timeStampLabel)
        addSubview(contentLabel)

        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(insetConstant)
            make.width.height.equalTo(imageViewWidthHeight)
        }

        authorLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(insetConstant)
            make.top.equalTo(imageView.snp.top)
        }

        timeStampLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(imageView.snp.leading).offset(timeLabelOffset)
            make.top.equalTo(imageView.snp.top)
        }

        contentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(insetConstant)
            make.trailing.equalTo(imageView.snp.leading).offset(timeLabelOffset)
            make.bottom.equalTo(imageView.snp.bottom)
            make.top.equalTo(authorLabel.snp.bottom).offset(offsetConstant)
        }
    }

    func setupImage() {
        if let imageUrl = post?.featuredMediaImages?.thumbnail?.url {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl)
        }
    }
}
