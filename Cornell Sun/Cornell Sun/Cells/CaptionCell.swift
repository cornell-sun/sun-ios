//
//  CaptionCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

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
        label.textColor = .black
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

    func updateCaption(index: Int) {
        captionLabel.text = post?.postAttachments[index].caption ?? ""
        captionLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(18)
            make.right.equalToSuperview().inset(18)
        }
    }

    func setupViews() {
        self.backgroundColor = .white
        addSubview(captionLabel)
        addSubview(divider)
        captionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(18)
            make.right.equalToSuperview().inset(18)
        }

        divider.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.left.equalToSuperview().inset(18)
            make.right.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(1)
        }
    }
}
