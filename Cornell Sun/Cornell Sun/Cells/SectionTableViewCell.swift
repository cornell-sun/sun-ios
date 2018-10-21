//
//  SectionTableViewCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/4/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    let sectionImageSize: CGFloat = 16.0
    let sectionImageLeading: CGFloat = 19.0
    let detailImageTrailing: CGFloat = 17.5
    let titleLabelPadding: CGFloat = 7.0

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 4
        label.textColor = .black
        label.font = .secondaryHeader
        return label
    }()
    
    let sectionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let detailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "disclosureArrow")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(sectionImageView)
        contentView.addSubview(detailImageView)
        
        layout()
    }
    
    func layout() {
        
        sectionImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(sectionImageSize)
            make.leading.equalTo(sectionImageLeading)
        }
        
        detailImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(detailImageTrailing)
            make.width.height.equalTo(detailImageView.intrinsicContentSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(sectionImageView.snp.trailing).offset(titleLabelPadding)
            make.trailing.lessThanOrEqualTo(detailImageView.snp.leading).inset(titleLabelPadding)
            make.centerY.equalTo(sectionImageView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
