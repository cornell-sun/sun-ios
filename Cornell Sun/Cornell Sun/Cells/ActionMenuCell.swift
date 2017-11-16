//
//  ActionMenuCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

protocol HeartPressedDelegate: class {
    func didPressHeart(_ cell: MenuActionCell)
}

protocol BookmarkPressedDelegate: class {
    func didPressBookmark(_ cell: MenuActionCell)
}

protocol SharePressedDelegate: class {
    func didPressShare()
}

final class MenuActionCell: UICollectionViewCell {

    weak var heartDelegate: HeartPressedDelegate?
    weak var bookmarkDelegate: BookmarkPressedDelegate?
    weak var shareDelegate: SharePressedDelegate?

    let heartWidth = 23.0
    let shareWidth = 20.0
    let bookmarkWidth = 15.0
    let imageHeight = 21.0
    let offset = 18
    lazy var heartButton: UIButton = {
        let button = UIButton(type: .custom)
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(MenuActionCell.heartPressed(_:)), for: .touchUpInside)
        self.contentView.addSubview(button)
        return button
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

    @objc func heartPressed(_ button: UIButton) {
        heartDelegate?.didPressHeart(self)
    }

    @objc func bookmarkPressed(_ button: UIButton) {
        bookmarkDelegate?.didPressBookmark(self)
    }

    @objc func sharePressed(_ button: UIButton) {
        shareDelegate?.didPressShare()
    }

    override func prepareForReuse() {
        heartButton.setImage(#imageLiteral(resourceName: "heart"), for: .normal)
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark"), for: .normal)
    }

    func setBookmarkImage(didSelectBookmark: Bool) {
        let image = didSelectBookmark ? #imageLiteral(resourceName: "bookmarkPressed") : #imageLiteral(resourceName: "bookmark")
        bookmarkButton.setImage(image, for: .normal)
    }

    func setupViews(forBookmarks: Bool) {
        self.backgroundColor = .white

        heartButton.snp.makeConstraints { (make) in
            make.width.equalTo(heartWidth)
            make.height.equalTo(imageHeight)
            make.centerY.equalToSuperview()
            make.left.equalTo(offset)
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

            if forBookmarks {
                make.right.equalTo(bookmarkButton.snp.left).offset(-24)
            } else {
            make.left.equalTo(heartButton.snp.right).offset(10)
            }
        }

        heartButton.isHidden = forBookmarks
    }
}
