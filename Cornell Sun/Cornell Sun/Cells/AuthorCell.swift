//
//  AuthorCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/13/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

final class AuthorCell: UICollectionViewCell {

    var insetConstant: CGFloat = 17

    var post: PostObject? {
        didSet {
            authorLabel.text = post?.author?.name
            timeStampLabel.text = post?.datePosted.timeAgoSinceNow()
        }
    }

    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = UIFont(name: "Georgia", size: 13)
        label.textColor = .darkGrey
        return label
    }()

    let timeStampLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .authorCell
        label.textColor = .darkGrey
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
        addSubview(authorLabel)
        addSubview(timeStampLabel)
        authorLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(insetConstant)
        }

        timeStampLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(insetConstant)
        }
    }
}
