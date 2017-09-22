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
import SnapKit

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
        if let heroImageUrl = post?.mediaLink, heroImageUrl != "http://i1.wp.com/cornellsun.com/wp-content/uploads/2017/09/Cafézoide-1.jpg?resize=800%2C600" {
            print(heroImageUrl)
            heroImageView.pin_setImage(from: URL(string: heroImageUrl)!)
            //heroImageView.loadImageUsingUrlString(heroImageUrl)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
         let cache = PINRemoteImageManager.shared().cache
        cache.memoryCache.costLimit = UInt(600 * 600 * 150 * UIScreen.main.scale)
        cache.diskCache.byteLimit = 100 * 1024 * 1024
        cache.diskCache.ageLimit = 60*60*24*5
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(titleLabel)
        addSubview(heroImageView)

        heroImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(self.bounds.height * 0.60)
            make.width.equalToSuperview().offset(-20)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalToSuperview().offset(-20)
        }
    }
}
