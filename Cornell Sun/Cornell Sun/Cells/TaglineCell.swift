//
//  TaglineCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/13/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

final class TaglineCell: UICollectionViewCell {

    var post: PostObject? {
        didSet {
            if let post = post {
                taglineLabel.text = post.excerpt.removingHTMLEntities.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                taglineLabel.setLineSpacing(to: 5)
            }
        }
    }

    let taglineLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 3
        label.font = .photoCaption
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
        addSubview(taglineLabel)
        taglineLabel.snp.makeConstraints { (make) in
//            make.centerY.equalToSuperview()
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 17, bottom: 5, right: 5))
        }
    }
}
