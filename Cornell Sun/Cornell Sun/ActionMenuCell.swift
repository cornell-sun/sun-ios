//
//  ActionMenuCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

final class MenuActionCell: UICollectionViewCell {

//    var post: PostObject? {
//        didSet {
//            titleLabel.text = post?.title
//        }
//    }

    let heartImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "heart")
        return image
    }()

    let commentImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "comment")
        return image
    }()

    let shareImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "share")
        return image
    }()

    let bookmarkImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "bookmark")
        return image
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
        addSubview(heartImageView)
        //addSubview(commentImageView)
        addSubview(shareImageView)
        addSubview(bookmarkImageView)
        heartImageView.snp.makeConstraints { (make) in
            make.width.equalTo(28.5)
            make.height.equalTo(28.5)
            make.centerY.equalToSuperview()
            make.left.equalTo(15.5)
        }

//        commentImageView.snp.makeConstraints { (make) in
//            make.width.equalTo(28.5)
//            make.height.equalTo(25)
//            make.centerY.equalToSuperview()
//            make.left.equalTo(heartImageView.snp.right).offset(10)
//        }

        shareImageView.snp.makeConstraints { (make) in
            make.width.equalTo(28.5)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(heartImageView.snp.right).offset(10)
        }

        bookmarkImageView.snp.makeConstraints { (make) in
            make.width.equalTo(28.5)
            make.height.equalTo(28.5)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15.5)
        }
    }
}
