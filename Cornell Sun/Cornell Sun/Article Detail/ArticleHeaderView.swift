//
//  ArticleHeaderView.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 11/16/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

class ArticleHeaderView: UIView {
    let leadingOffset: CGFloat = 17.5
    let categoryLabelTopOffset: CGFloat = 18.5
    let categoryLabelHeight: CGFloat = 20
    let titleLabelTopOffset: CGFloat = 12.0
    let titleLabelHeight: CGFloat = 100
    let imageViewHeight: CGFloat = 250.0
    let imageViewTopOffset: CGFloat = 12.0
    let timeStampTopOffset: CGFloat = 14.5
    let timeStampHeight: CGFloat = 15
    let authorLabelHeight: CGFloat = 15
    let captionLabelTopOffset: CGFloat = 4
    let captionLabelBottomOffset: CGFloat = 9.5

    var categoryLabel: UILabel!
    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var timeStampLabel: UILabel!
    var captionLabel: UILabel!
    let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    convenience init(article: PostObject, frame: CGRect) {
        self.init(frame: frame)
        setupWithPost(article)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        categoryLabel = UILabel(frame: .zero)
        categoryLabel.textColor = .black
        categoryLabel.font = .articleViewTheme
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingOffset)
            make.top.equalToSuperview().offset(categoryLabelTopOffset)
            make.height.equalTo(categoryLabelHeight)
        }

        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = .blackThree
        titleLabel.font = .articleTitle
        titleLabel.numberOfLines = 6
        titleLabel.lineBreakMode = .byTruncatingTail
        addSubview(titleLabel)

        timeStampLabel = UILabel(frame: .zero)
        timeStampLabel.textColor = .darkGrey
        timeStampLabel.font = .author
        addSubview(timeStampLabel)
        timeStampLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(titleLabel.snp.bottom).offset(timeStampTopOffset)
            make.height.equalTo(timeStampHeight)
        }

        authorLabel = UILabel(frame: .zero)
        authorLabel.textColor = .darkGrey
        authorLabel.font = .author
        addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingOffset)
            make.bottom.equalTo(timeStampLabel.snp.bottom)
            make.height.equalTo(authorLabelHeight)
        }

        addSubview(heroImageView)
        heroImageView.snp.makeConstraints { make in
            make.top.equalTo(timeStampLabel.snp.bottom).offset(imageViewTopOffset)
            make.width.leading.centerX.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }

        captionLabel = UILabel(frame: .zero)
        captionLabel.font = .caption
        captionLabel.textColor = .darkGrey
        captionLabel.numberOfLines = 0
        addSubview(captionLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupWithPost(_ post: PostObject) {
        setupHeroImage(with: post)
        categoryLabel.text = post.primaryCategory
        titleLabel.text = post.title
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(categoryLabel.snp.bottom).offset(titleLabelTopOffset)
        }
        timeStampLabel.text = post.datePosted.timeAgoSinceNow()
        authorLabel.text = "By \(post.author!.name.removingHTMLEntities.htmlToString)"
        captionLabel.text = post.caption
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(captionLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            let height = post.caption.height(withConstrainedWidth: UIScreen.main.bounds.width - 2 * leadingOffset, font: .caption) + captionLabelBottomOffset
            make.height.equalTo(height)
            make.bottom.equalToSuperview()
        }
    }

    func setupHeroImage(with post: PostObject) {
        if let heroImageUrl = URL(string: post.mediumLargeImageLink) {
            heroImageView.kf.indicatorType = .activity
            heroImageView.kf.setImage(with: heroImageUrl)
        }
    }

}
