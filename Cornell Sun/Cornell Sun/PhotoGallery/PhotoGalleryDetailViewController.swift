//
//  PhotoGalleryDetailViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/28/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit

struct PhotoGalleryDetailConstants {
    static let closeButtonInsets = 16
}

class PhotoGalleryDetailViewController: UIViewController {
    var photoGallery: PhotoGallery!
    var attachments: [PostAttachmentObject]!
    var selectedIndex: IndexPath!
    var updateMainGallery: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        closeButton.setBackgroundImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.tintColor = .white

        isMotionEnabled = true
        photoGallery = PhotoGallery(attachments: attachments, height: view.bounds.width / 1.5, width: view.bounds.width, pinchToZoom: true, viewHeight: view.bounds.height)
        photoGallery.displayPageControl = false
        
        view.addSubview(photoGallery)
        view.addSubview(closeButton)

        photoGallery.updateScrollPosition = { item in
            self.updateMainGallery?(item)
        }

        photoGallery.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(PhotoGalleryDetailConstants.closeButtonInsets)
            } else {
                make.top.equalToSuperview().offset(PhotoGalleryDetailConstants.closeButtonInsets)
            }
            make.leading.equalToSuperview().offset(PhotoGalleryDetailConstants.closeButtonInsets)
        }
        view.layoutIfNeeded()
        photoGallery.scrollTo(indexPath: selectedIndex)
        
        //MARK: - Add Swipe down Gesture Recognizer
        let slideDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        slideDownGesture.direction = .down
        view.addGestureRecognizer(slideDownGesture)
        
    }

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
