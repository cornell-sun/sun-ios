//
//  ImageCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/22/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import PINRemoteImage
import SnapKit

func imageSectionController() -> ListSingleSectionController {
    let configureBlock = { (item: Any, cell: UICollectionViewCell) in
        guard cell is ImageCell else {
            return
        }
    }

        let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
            guard let context = context else {
                return .zero
            }
            return CGSize(width: context.containerSize.width, height: 150)

        }
        return ListSingleSectionController(cellClass: ImageCell.self, configureBlock: configureBlock, sizeBlock: sizeBlock)
    }

final class ImageCell: UICollectionViewCell {

    var post: PostObject? {
        didSet {
            setupHeroImage()
        }
    }

    let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    fileprivate let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        //view.startAnimating()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityView.center = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
    }

    func setupViews() {
        addSubview(heroImageView)
        heroImageView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    func setupHeroImage() {
        if let heroImagelink = post?.mediaLink, let heroImageUrl = URL(string: heroImagelink) {
            //activityView.stopAnimating()
            heroImageView.pin_setImage(from: heroImageUrl)
        }
    }
}
