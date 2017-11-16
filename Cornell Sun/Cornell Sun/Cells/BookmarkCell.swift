//
//  BookmarkCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/16/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

final class BookmarkCell: UICollectionViewCell {

    var post: PostObject? {
        didSet {
            titleLabel.text = post?.title
            authorLabel.text = post?.author?.name
            timeStampLabel.text = post?.datePosted.timeAgoSinceNow()
            setupImage()
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 4
        label.font = .bookmarkTitle
        return label
    }()

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
        label.font = UIFont(name: "Georgia", size: 13)
        label.textColor = .black
        return label
    }()

    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = UIFont(name: "Georgia", size: 13)
        label.textColor = .black
        return label
    }()

    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .warmGrey
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.backgroundColor = .white
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(timeStampLabel)
        addSubview(divider)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(18)
            make.width.height.equalTo(100)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top)
            make.left.equalTo(imageView.snp.right).offset(12)
            make.right.equalToSuperview().inset(18)
        }

        authorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(12)
            make.bottom.equalTo(imageView.snp.bottom)
        }

        timeStampLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(18)
            make.bottom.equalTo(imageView.snp.bottom)
        }

        divider.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalToSuperview().inset(18)
            make.right.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(1)
        }
    }

    func setupImage() {
        if let imagelink = post?.thumbnailImageLink, let imageUrl = URL(string: imagelink) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl)
        }
    }
}
