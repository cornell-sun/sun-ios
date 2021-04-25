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
    let authorHeight: CGFloat = 13
    let imageLeadingConstant: CGFloat = 16
    
    var post: PostObject? {
        didSet {
            titleLabel.text = post?.title
            titleLabel.setLineSpacing(to: 4.5)
            authorLabel.text = ""
            if let author = post?.author?.byline.uppercased() {
                authorLabel.text = "BY " + author
            }
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
        label.font = .avenir12
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        setupViews()
    }

    func setupViews() {
        self.backgroundColor = darkModeEnabled ? .darkCell : .white
        titleLabel.textColor = darkModeEnabled ? .white90 : .black
        authorLabel.textColor = darkModeEnabled ? .white60 : .authorGray
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(authorLabel)
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(imageLeadingConstant)
            make.width.height.equalTo(imageViewWidthHeight)
        }

        authorLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(offsetConstant)
            make.trailing.equalToSuperview().inset(offsetConstant)
            make.bottom.equalTo(imageView.snp.bottom)
            make.height.equalTo(authorHeight)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.top)
            make.left.equalTo(imageView.snp.right).offset(offsetConstant)
            make.right.equalToSuperview().inset(insetConstant)
            make.bottom.lessThanOrEqualTo(authorLabel.snp.top).offset(-titleBottomInset)
        }

    }

    func setupImage() {
        if let imageUrl = post?.featuredMediaImages?.thumbnail?.url {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: imageUrl)
        }
    }
}
