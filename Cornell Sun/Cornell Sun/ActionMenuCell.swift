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
    let offset = 15.5
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
        setupViews()
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

    func setupViews() {
        self.backgroundColor = .white

        heartButton.snp.makeConstraints { (make) in
            make.width.equalTo(heartWidth)
            make.height.equalTo(imageHeight)
            make.centerY.equalToSuperview()
            make.left.equalTo(offset)
        }

//        commentImageView.snp.makeConstraints { (make) in
//            make.width.equalTo(28.5)
//            make.height.equalTo(25)
//            make.centerY.equalToSuperview()
//            make.left.equalTo(heartButton.snp.right).offset(10)
//        }

        shareImageView.snp.makeConstraints { (make) in
            make.width.equalTo(shareWidth)
            make.height.equalTo(imageHeight)
            make.centerY.equalToSuperview()
            make.left.equalTo(heartButton.snp.right).offset(10)
        }

        bookmarkButton.snp.makeConstraints { (make) in
            make.width.equalTo(bookmarkWidth)
            make.height.equalTo(imageHeight)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(offset)
        }
    }
}
