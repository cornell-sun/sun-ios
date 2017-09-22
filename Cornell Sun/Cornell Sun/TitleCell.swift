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

    var post: PostObject? {
        didSet {
            titleLabel.text = post?.title
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 2
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            //make.centerX.equalToSuperview()
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(5, 5, 5, 5))
        }
    }
}
