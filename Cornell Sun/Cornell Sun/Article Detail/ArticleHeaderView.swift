//
//  ArticleHeaderView.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 11/16/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

protocol ArticleHeaderDelegate: class {
    func articleHeaderDidPressOnAuthor()
}

class ArticleHeaderView: UIView {

    let authorLabelFont: UIFont = .secondaryHeader
    let authorLabelHeight: CGFloat = 15
    let authorLabelTopOffset: CGFloat = 46
    let captionLabelBottomOffset: CGFloat = 9.5
    let captionLabelTopOffset: CGFloat = 4
    let categoryLabelHeight: CGFloat = 20
    let categoryLabelTopOffset: CGFloat = 18.5
    let creditsLabelHeight: CGFloat = 15
    let creditsLabelInset: CGFloat = 10.5
    let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let imageViewHeight: CGFloat = 250.0
    let imageViewTopOffset: CGFloat = 10.5
    let leadingOffset: CGFloat = 16
    let timeStampHeight: CGFloat = 15
    let titleLabelHeight: CGFloat = 100
    let titleLabelTopOffset: CGFloat = 12.0

    var authorButton: UIButton!
    var captionLabel: UILabel!
    var categoryLabel: UILabel!
    var creditsLabel: UILabel!
    var timeStampLabel: UILabel!
    var titleLabel: UILabel!
    var width: CGFloat = 0

    private let readableDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()

    weak var delegate: ArticleHeaderDelegate?

    convenience init(article: PostObject, frame: CGRect, delegate: ArticleHeaderDelegate?, width: CGFloat) {
        self.init(frame: frame)
        self.delegate = delegate
        self.width = width - 2 * leadingOffset
        setupWithPost(article)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        categoryLabel = UILabel(frame: .zero)
        categoryLabel.font = authorLabelFont
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingOffset)
            make.top.equalToSuperview().offset(categoryLabelTopOffset)
            make.height.equalTo(categoryLabelHeight)
        }

        titleLabel = UILabel(frame: .zero)
        titleLabel.font = .articleTitle
        titleLabel.numberOfLines = 6
        titleLabel.lineBreakMode = .byTruncatingTail
        addSubview(titleLabel)

        captionLabel = UILabel(frame: .zero)
        captionLabel.font = .photoCaption
        captionLabel.numberOfLines = 0
        addSubview(captionLabel)

        creditsLabel = UILabel()
        creditsLabel.font = .photoCaptionCredit
        addSubview(creditsLabel)
        creditsLabel.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.height.equalTo(creditsLabelHeight)
        }

        addSubview(heroImageView)
        heroImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(imageViewTopOffset)
            make.width.leading.centerX.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }

        authorButton = UIButton()
        authorButton.titleLabel?.font = .secondaryHeader
        authorButton.titleLabel?.numberOfLines = 0
        if #available(iOS 11.0, *) {
            authorButton.contentHorizontalAlignment = .leading
            authorButton.contentVerticalAlignment = .top
        }
        authorButton.addTarget(self, action: #selector(authorButtonPressed), for: .touchUpInside)
        addSubview(authorButton)
        authorButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(captionLabel.snp.bottom).offset(authorLabelTopOffset)
        }

        timeStampLabel = UILabel(frame: .zero)
        timeStampLabel.font = .subSecondaryHeader
        addSubview(timeStampLabel)
        timeStampLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingOffset)
            make.top.equalTo(authorButton.snp.bottom)
            make.height.equalTo(timeStampHeight)
            make.bottom.equalToSuperview()
        }

        updateColors()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateColors() {
        categoryLabel.textColor = darkModeEnabled ? .white90 : .black60
        titleLabel.textColor = darkModeEnabled ? .white90 : .black90
        captionLabel.textColor = darkModeEnabled ? .white90 : .black90
        creditsLabel.textColor = darkModeEnabled ? .white40 : .black40
        authorButton.setTitleColor(darkModeEnabled ? .white90 : .black90, for: .normal)
        timeStampLabel.textColor = darkModeEnabled ? .white40 : .black40
    }

    func setupWithPost(_ post: PostObject) {
        categoryLabel.text = post.primaryCategory.htmlToString.uppercased()
        titleLabel.text = post.title
        titleLabel.setLineSpacing(to: 5)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(categoryLabel.snp.bottom).offset(titleLabelTopOffset)
        }

        timeStampLabel.text = readableDateFormatter.string(from: post.date)
        if let authors = post.author {
            let title = "By \(authors.byline)"
            authorButton.setTitle(title, for: .normal)
            let height = title.height(withConstrainedWidth: width, font: authorLabelFont)
            authorButton.snp.makeConstraints { make in
                make.height.equalTo(height + 12)
            }
        }
        if let caption = post.featuredMediaCaption {
            captionLabel.text = caption.htmlToString
        }
        captionLabel.setLineSpacing(to: 2)

        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(captionLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
        }
        if let credits = post.featuredMediaCredit {
            creditsLabel.text = credits
        }
        setupHeroImage(with: post)
    }

    func setupHeroImage(with post: PostObject) {
        if let heroImageUrl = post.featuredMediaImages?.mediumLarge?.url {
            heroImageView.kf.indicatorType = .activity
            heroImageView.kf.setImage(with: heroImageUrl)
        } else {
            heroImageView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            captionLabel.text = ""
            creditsLabel.text = ""
            captionLabel.snp.remakeConstraints { make in
                make.top.equalTo(heroImageView.snp.bottom).offset(captionLabelTopOffset)
                make.height.equalTo(0)
                make.leading.trailing.equalToSuperview()
            }
            creditsLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
                make.top.equalTo(captionLabel.snp.bottom)
                make.leading.trailing.equalToSuperview()
            }

            authorButton.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(leadingOffset)
                make.top.equalTo(titleLabel.snp.bottom).offset(titleLabelTopOffset)
                if let authors = authorButton.titleLabel?.text {
                    let height = authors.height(withConstrainedWidth: authorButton.bounds.width, font: authorLabelFont)
                    make.height.equalTo(height)
                }

            }
        }
    }

    @objc func authorButtonPressed() {
        delegate?.articleHeaderDidPressOnAuthor()
    }

}
