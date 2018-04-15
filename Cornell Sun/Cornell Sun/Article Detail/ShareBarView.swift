//
//  ShareBarView.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 2/24/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

protocol ShareBarViewDelegate: class {
    func shareBarDidPressShare(_ view: ShareBarView)
    func shareBarDidPressBookmark(_ view: ShareBarView)
}

class ShareBarView: UIView {
    var topSeparatorLabel: UILabel!
    var bookmarkButton: UIButton!
    var shareButton: UIButton!
    weak var delegate: ShareBarViewDelegate?

    let topSeparatorHeight: CGFloat = 1
    let bookmarkTrailingPadding: CGFloat = 18
    let bookmarkWidth: CGFloat = 15
    let bookmarkHeight: CGFloat = 20
    let shareTrailingPadding: CGFloat = 25
    let shareWidth: CGFloat = 19
    let shareHeight: CGFloat = 21

    init() {
        super.init(frame: .zero)
        backgroundColor = .white

        topSeparatorLabel = UILabel()
        topSeparatorLabel.backgroundColor = .white
        addSubview(topSeparatorLabel)
        topSeparatorLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(topSeparatorHeight)
        }

        bookmarkButton = UIButton()
        bookmarkButton.imageView?.contentMode = .scaleAspectFit
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark"), for: .normal)
        bookmarkButton.addTarget(self, action: #selector(bookmark), for: .touchUpInside)
        addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(bookmarkTrailingPadding)
            make.width.equalTo(bookmarkWidth)
            make.height.equalTo(bookmarkHeight)
            make.centerY.equalToSuperview()
        }

        shareButton = UIButton()
        shareButton.imageView?.contentMode = .scaleAspectFit
        shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(-shareTrailingPadding)
            make.width.equalTo(shareWidth)
            make.height.equalTo(shareHeight)
            make.centerY.equalToSuperview()
        }

    }

    @objc func bookmark() {
        delegate?.shareBarDidPressBookmark(self)
    }

    @objc func share() {
        delegate?.shareBarDidPressShare(self)
    }

    func setBookmarkImage(didSelectBookmark: Bool) {
        let image = didSelectBookmark ? #imageLiteral(resourceName: "bookmarkPressed") : #imageLiteral(resourceName: "bookmark")
        bookmarkButton.setImage(image, for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
