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
    let topOffset: CGFloat = 2
    let bottomInset: CGFloat = 10
    let height: CGFloat = 13
    
    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

    var post: PostObject? {
        didSet {
            if let post = post, let authors = post.author {
                authorLabel.text = "By \(authors.byline)".uppercased()
            }
        }
    }

    let authorLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 1
        label.font = .subSecondaryHeader
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
        self.backgroundColor = darkModeEnabled ? .black : .white
        authorLabel.textColor = darkModeEnabled ? .white90 : .black60
        addSubview(authorLabel)
        authorLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topOffset)
            make.leading.trailing.equalToSuperview().inset(insetConstant)
        }
    }
}
