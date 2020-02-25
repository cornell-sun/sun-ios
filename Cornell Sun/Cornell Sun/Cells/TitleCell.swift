//
//  TitleCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/22/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

final class TitleCell: UICollectionViewCell {
    var topOffset: CGFloat = 15
    var leftRightInset: CGFloat = 17
    var bottomInset: CGFloat = 5
    
    var post: PostObject? {
        didSet {
            if let post = post {
                titleLabel.text = post.title
                titleLabel.setLineSpacing(to: 5)
            }
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 4
        label.font = .articleTitle
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    override func prepareForReuse() {
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        self.backgroundColor = darkModeEnabled ? .darkCell : .white
        titleLabel.textColor = darkModeEnabled ? .white90 : .black90
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(leftRightInset)
            make.top.equalToSuperview().offset(topOffset)
        }
    }
}
