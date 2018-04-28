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
            setupViews()
        }
    }

    weak var photoGalleryDelegate: PhotoChangedDelegate?

    var slideShow: PhotoGallery!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func prepareForReuse() {

    }

    func setupViews() {
        slideShow = PhotoGallery(attachments: post!.postAttachments, height: self.bounds.height, width: self.bounds.width)

        addSubview(slideShow)
        slideShow.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        slideShow.updateCaption = { page in
            self.photoGalleryDelegate?.photoDidChange(page)
        }
    }

//    @objc func didTapPhotos() {
//        let fullscreenVC = slideShow.presentFullScreenController(from: getCurrentViewController()!)
//        fullscreenVC.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
//        fullscreenVC.captions = post?.postAttachments.compactMap {$0.caption}
//        fullscreenVC.captionLabel.text = post?.postAttachments[slideShow.currentPage].caption ?? ""
//    }
    func setUpImages() {
        var kingfisherSource: [KingfisherSource] = []
        guard let postAttachments = post?.postAttachments else { return }
        for attachment in postAttachments {
            let source = KingfisherSource(url: attachment.url)
            kingfisherSource.append(source)
        }
        //slideShow.setImageInputs(kingfisherSource)
    }

}
