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

    let categoryLabelLeading = 16.0
    let dividerPadding = 14.0

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
        label.font = .avenir16
        label.numberOfLines = 1
        return label
    }()

    let divider: UIView = {
        let view = UIView()
        return view
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
        categoryLabel.textColor = darkModeEnabled ? .white90 : .black60
        divider.backgroundColor = darkModeEnabled ? .white40 : .dividerGray
        addSubview(categoryLabel)
        addSubview(divider)
        categoryLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.leading.equalTo(categoryLabelLeading)
        }
        divider.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.leading.equalToSuperview().offset(dividerPadding)
            make.trailing.equalToSuperview().offset(-dividerPadding)
            make.bottom.equalToSuperview().inset(1)
        }
    }
}
