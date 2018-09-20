//
//  CategoryCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/26/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

final class CategoryCell: UICollectionViewCell {

    var categoryLabelLeading = 17.0

    var post: PostObject? {
        didSet {
            categoryLabel.text = post?.primaryCategory.htmlToString.uppercased()
        }
    }
    
    var adLabel: String? {
        didSet {
            if let text = adLabel {
                categoryLabel.text = text
            }
        }
    }

    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .secondaryHeader
        label.textColor = .black60
        label.numberOfLines = 2
        return label
    }()

    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .black40
        return view
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
        addSubview(categoryLabel)
        addSubview(divider)
        categoryLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(categoryLabelLeading)
        }
        divider.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
        }
    }
}
