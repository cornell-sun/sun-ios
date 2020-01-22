//
//  ActionMenuCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit
import Crashlytics

protocol BookmarkPressedDelegate: class {
    func didPressBookmark(_ cell: MenuActionCell)
}

protocol SharePressedDelegate: class {
    func didPressShare()
}

final class MenuActionCell: UICollectionViewCell {

    var post: PostObject? {
        didSet {
            timeStampLabel.text = post?.date.timeAgoSinceNow()
        }
    }

    weak var bookmarkDelegate: BookmarkPressedDelegate?
    weak var shareDelegate: SharePressedDelegate?

    let heartWidth = 23.0
    let shareWidth = 23.0
    let bookmarkWidth = 15
    let imageHeight = 32
    let inset = 16
    let shareTrailingPadding = 28
    
    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .subSecondaryHeader
        label.textColor = darkModeEnabled ? .white60 : .black60
        self.contentView.addSubview(label)
        return label
    }()

    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleToFill
        let buttonImage = darkModeEnabled ? "bookmarkIconDark" : "bookmarkIconLight"
        button.setImage(UIImage(named: buttonImage), for: .normal)
        button.addTarget(self, action: #selector(MenuActionCell.bookmarkPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()

    let commentImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = #imageLiteral(resourceName: "comment")
        return image
    }()

    lazy var shareImageView: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        let buttonImage = darkModeEnabled ? "shareIconDark" : "shareIconDark"
        button.setImage(UIImage(named: buttonImage), for: .normal)
        button.addTarget(self, action: #selector(MenuActionCell.sharePressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func bookmarkPressed(_ button: UIButton) {
        bookmarkDelegate?.didPressBookmark(self)
        Answers.logCustomEvent(withName: "Bookmark Pressed", customAttributes: nil)
    }

    @objc func sharePressed(_ button: UIButton) {
        shareDelegate?.didPressShare()
        Answers.logCustomEvent(withName: "Shared Pressed", customAttributes: nil)
    }

    func setBookmarkImage(didSelectBookmark: Bool) {
        let image: UIImage!
        
        if darkModeEnabled {
            image = didSelectBookmark ? UIImage(named: "bookmarkIconSelectedDark") : UIImage(named: "bookmarkIconDark")
        } else {
            image = didSelectBookmark ? UIImage(named: "bookmarkPressed") : UIImage(named: "bookMarkIconLight")
        }
        bookmarkButton.setImage(image, for: .normal)
    }

    func setupViews(forBookmarks: Bool) {
        self.backgroundColor = darkModeEnabled ? .black : .white

        if forBookmarks {
            let bookmarkImage = darkModeEnabled ? "bookmarkIconSelectedDark" : "bookmarkIconSelectedLight"
            bookmarkButton.setImage(UIImage(named: bookmarkImage), for: .normal)
        }

        timeStampLabel.snp.makeConstraints { make in
            make.leading.equalTo(inset)
            make.centerY.equalToSuperview()
        }

        bookmarkButton.snp.makeConstraints { make in
            make.width.equalTo(bookmarkWidth)
            make.height.equalTo(imageHeight)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-inset)
        }

        shareImageView.snp.makeConstraints { make in
            make.width.equalTo(shareWidth)
            make.height.equalTo(imageHeight)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(-shareTrailingPadding)
        }
    }
}
