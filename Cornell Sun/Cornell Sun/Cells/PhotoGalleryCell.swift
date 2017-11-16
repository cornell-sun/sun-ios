//
//  WeekInPhotosCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/13/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit
import Kingfisher
import ImageSlideshow

protocol PhotoChangedDelegate: class {
    func photoDidChange(_ index: Int)
}
final class PhotoGalleryCell: UICollectionViewCell {

    var post: PostObject? {
        didSet {
            setUpImages()
        }
    }

    var photoGalleryDelegate: PhotoChangedDelegate?

    let slideShow: ImageSlideshow = {
        let slideShow = ImageSlideshow()
        slideShow.contentScaleMode = .scaleAspectFill
        slideShow.circular = false
        slideShow.pageControl.backgroundColor = .clear
        slideShow.pageControlPosition = .custom(padding: -15.0)
        slideShow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        return slideShow

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
    }

    func setupViews() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapPhotos))
        slideShow.addGestureRecognizer(gestureRecognizer)

        addSubview(slideShow)
        slideShow.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        slideShow.currentPageChanged = { page in
            self.photoGalleryDelegate?.photoDidChange(page)
        }

    }

    @objc func didTapPhotos() {
        let fullscreenVC = slideShow.presentFullScreenController(from: getCurrentViewController()!)
        fullscreenVC.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
        fullscreenVC.captions = post?.photoGalleryObjects.map({$0.caption})
        fullscreenVC.captionLabel.text = post?.photoGalleryObjects[slideShow.currentPage].caption

    }
    func setUpImages() {
        var kingfisherSource: [KingfisherSource] = []
        for photoGalleryObject in post!.photoGalleryObjects {
            let source = KingfisherSource(urlString: photoGalleryObject.fullImageLink)
            kingfisherSource.append(source!)
        }
        slideShow.setImageInputs(kingfisherSource)
    }

}
