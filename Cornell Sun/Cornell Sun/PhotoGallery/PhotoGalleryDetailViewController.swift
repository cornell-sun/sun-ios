//
//  PhotoGalleryDetailViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/28/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

class PhotoGalleryDetailViewController: UIViewController {
    var photoGallery: PhotoGallery!
    var height: CGFloat!
    var width: CGFloat!
    var attachments: [PostAttachmentObject]!
    var selectedIndex: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        photoGallery = PhotoGallery(attachments: attachments, height: height, width: width)
        photoGallery.scrollTo(indexPath: selectedIndex)
        view.addSubview(photoGallery)

        photoGallery.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}

