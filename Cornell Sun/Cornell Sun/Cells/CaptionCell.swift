//
//  CaptionCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

struct CaptionCellConstants {
    static let captionVerticalInset = 10
    static let captionHorizontalInset = 18

    static let dividerHeight = 1
    static let dividerHorizontalInset = 18
    static let dividerBottom = 1
}

final class CaptionCell: UICollectionViewCell {

    var post: PostObject? {
        didSet {
            if let caption = post?.postAttachments.first?.caption {
                captionLabel.text = caption
            }
        }
    }

    let captionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 3
        label.font = .photoCaption
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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateCaption(index: Int) {
        captionLabel.text = post?.postAttachments[index].caption ?? ""
        captionLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(CaptionCellConstants.captionVerticalInset)
            make.leading.trailing.equalToSuperview().inset(CaptionCellConstants.captionHorizontalInset)
        }
    }

    func setupViews() {
        self.backgroundColor = darkModeEnabled ? .darkCell : .white
        addSubview(captionLabel)
        addSubview(divider)
        captionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(CaptionCellConstants.captionVerticalInset)
            make.leading.trailing.equalToSuperview().inset(CaptionCellConstants.captionHorizontalInset)
        }

        divider.snp.makeConstraints { (make) in
            make.height.equalTo(CaptionCellConstants.dividerHeight)
            make.leading.trailing.equalToSuperview().inset(CaptionCellConstants.dividerHorizontalInset)
            make.bottom.equalToSuperview().inset(CaptionCellConstants.dividerBottom)
        }
        
        captionLabel.textColor = darkModeEnabled ? .white : .black
        divider.backgroundColor = darkModeEnabled ? .white60 : .black40
    }
}
