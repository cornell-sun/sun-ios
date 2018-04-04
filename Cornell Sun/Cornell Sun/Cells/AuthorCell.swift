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

    let insetConstant: CGFloat = 17

    var post: PostObject? {
        didSet {
            if let post = post, let author = post.author {
                authorLabel.text = "By \(author.name)"
            }
        }
    }

    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .photoCaption
        label.textColor = .black90
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
        authorLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(insetConstant)
        }
    }
}
