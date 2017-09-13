//
//  ArticleCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/4/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import PINRemoteImage
import PINCache

class ArticleCell: UICollectionViewCell {
    var post: PostObject? {
        didSet {
            titleLabel.text = post?.title
            setupHeroImage()
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.numberOfLines = 2
        return label
    }()

    let heroImageView: ArticleImageView = {
        let imageView = ArticleImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    func setupHeroImage() {
        if let heroImageUrl = post?.mediaLink {
            heroImageView.pin_setImage(from: URL(string: heroImageUrl)!)
            //heroImageView.loadImageUsingUrlString(heroImageUrl)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(titleLabel)
        addSubview(heroImageView)

        addConstraintsWithFormat("H:|-[v0]-|", views: heroImageView)
        addConstraintsWithFormat("H:|-[v0]-|", views: titleLabel)

        addConstraintsWithFormat("V:|-[v0]-60-[v1]-|", views: heroImageView, titleLabel)
    }
}
