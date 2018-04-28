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
            titleLabel.text = post?.title
            authorLabel.text = post?.author[0].name
            setupImage()
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

    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .black40
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
        addSubview(divider)
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

        divider.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalToSuperview().inset(insetConstant)
            make.right.equalToSuperview().inset(insetConstant)
            make.bottom.equalToSuperview().inset(1)
        }
    }

    func setupImage() {
        if let imageUrl = post?.featuredMediaImages.thumbnail?.url {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl)
        }
    }
}
