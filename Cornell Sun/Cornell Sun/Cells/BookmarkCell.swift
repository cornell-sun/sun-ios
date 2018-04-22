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

    let insetConstant: CGFloat = 18
    let offsetConstant: CGFloat = 12
    let imageViewWidthHeight: CGFloat = 100
    let titleBottomInset: CGFloat = 8.5

    var post: PostObject? {
        didSet {
            if let post = post, let author = post.author {
                titleLabel.text = post.title
                authorLabel.text = "By " + author.name
                setupImage()
            }
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 4
        label.font = .articleTitle
        label.textAlignment = .left
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
        label.font = .cellInformationText
        label.textColor = .black
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
        self.backgroundColor = .white
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(insetConstant)
            make.width.height.equalTo(imageViewWidthHeight)
        }

        authorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imageView.snp.right).offset(offsetConstant)
            make.bottom.equalTo(imageView.snp.bottom)
            make.height.equalTo(13)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top)
            make.left.equalTo(imageView.snp.right).offset(offsetConstant)
            make.right.equalToSuperview().inset(insetConstant)
            make.bottom.lessThanOrEqualTo(authorLabel.snp.top).offset(-titleBottomInset)
        }

    }

    func setupImage() {
        if let imagelink = post?.thumbnailImageLink, let imageUrl = URL(string: imagelink) {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl)
        }
    }
}
