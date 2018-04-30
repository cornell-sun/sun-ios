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
import Motion

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
    var photoGallery: PhotoGallery!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        photoGallery = PhotoGallery(attachments: post!.postAttachments, height: self.bounds.height, width: self.bounds.width)

        addSubview(photoGallery)
        photoGallery.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }

        photoGallery.updateCaption = { page in
            self.photoGalleryDelegate?.photoDidChange(page)
        }

        photoGallery.pushToDetail = { attachments, index in
            let detailPhotoVC = PhotoGalleryDetailViewController()
            detailPhotoVC.attachments = attachments
            detailPhotoVC.selectedIndex = index
            getCurrentViewController()?.motionTransitionType = .autoReverse(presenting: .zoom)
            getCurrentViewController()?.present(detailPhotoVC, animated: true, completion: nil)

            detailPhotoVC.updateMainGallery = { item in
                let index = IndexPath(item: item, section: 0)
                self.photoGallery.scrollTo(indexPath: index)
                self.photoGalleryDelegate?.photoDidChange(item)
            }
        }
    }
}
