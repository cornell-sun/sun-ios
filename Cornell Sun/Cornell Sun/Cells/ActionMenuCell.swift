//
//  ActionMenuCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

protocol BookmarkPressedDelegate: class {
    func didPressBookmark(_ cell: MenuActionCell)
}

protocol SharePressedDelegate: class {
    func didPressShare()
}

final class MenuActionCell: UICollectionViewCell {

    var post: PostObject? {
        didSet {
            timeStampLabel.text = post?.datePosted.timeAgoSinceNow()
        }
    }

    weak var bookmarkDelegate: BookmarkPressedDelegate?
    weak var shareDelegate: SharePressedDelegate?

    let heartWidth = 23.0
    let shareWidth = 20.0
    let bookmarkWidth = 15.0
    let imageHeight = 21.0
    let offset = 18

    lazy var timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .time
        self.contentView.addSubview(label)
        return label
    }()

    lazy var bookmarkButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "bookmark"), for: .normal)
        button.addTarget(self, action: #selector(MenuActionCell.bookmarkPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
    }()

    let commentImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "comment")
        return image
    }()

    lazy var shareImageView: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "share"), for: .normal)
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
    }

    @objc func sharePressed(_ button: UIButton) {
        shareDelegate?.didPressShare()
    }

    override func prepareForReuse() {
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark"), for: .normal)
    }

    func setBookmarkImage(didSelectBookmark: Bool) {
        let image = didSelectBookmark ? #imageLiteral(resourceName: "bookmarkPressed") : #imageLiteral(resourceName: "bookmark")
        bookmarkButton.setImage(image, for: .normal)
    }

    func setupViews(forBookmarks: Bool) {
        self.backgroundColor = .white

        timeStampLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(offset)
            make.centerY.equalToSuperview()
        }

        bookmarkButton.snp.makeConstraints { (make) in
            make.width.equalTo(bookmarkWidth)
            make.height.equalTo(imageHeight)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(offset)
        }

        shareImageView.snp.makeConstraints { (make) in
            make.width.equalTo(shareWidth)
            make.height.equalTo(imageHeight)
            make.centerY.equalToSuperview()
            make.right.equalTo(bookmarkButton.snp.left).offset(-24)
        }
    }
}
