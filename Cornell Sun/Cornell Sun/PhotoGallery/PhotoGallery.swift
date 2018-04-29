//
//  PhotoGallery.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/26/18. (21 years old)
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import SnapKit
import UICircularProgressRing
import Kingfisher
import Motion

class PhotoGallery: UIView {

    private var didSetupConstraints = false
    private var didSetupImages = false
    var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var attachments: [PostAttachmentObject]!
    private var pinchToZoom: Bool!
    private var height: CGFloat!

    var selectedIndex: IndexPath?
    var displayPageControl = true {
        didSet {
            pageControl.isHidden = !displayPageControl
        }
    }

    var updateCaption: ((Int) -> Void)?
    var pushToDetail: (([PostAttachmentObject], IndexPath) -> Void)?
    var updateScrollPosition: ((Int) -> Void)?

    init(attachments: [PostAttachmentObject], height: CGFloat, width: CGFloat, pinchToZoom: Bool = false, viewHeight: CGFloat = 0.0) {
        super.init(frame: .zero)

        self.attachments = attachments
        self.pinchToZoom = pinchToZoom
        self.height = height

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let itemHeight = viewHeight == 0.0 ? height : viewHeight
        layout.itemSize = CGSize(width: width, height: itemHeight)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .lightGray2
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "image-cell")

        if pinchToZoom {
            collectionView.backgroundColor = .black
        }

        pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = attachments.count
        pageControl.addTarget(self, action: #selector(updatePageDisplay), for: .valueChanged)

        addSubview(collectionView)
        addSubview(pageControl)

        self.setNeedsUpdateConstraints()
        collectionView.layoutIfNeeded()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func updateConstraints() {

        if !didSetupConstraints {

            collectionView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            pageControl.snp.makeConstraints { make in
                make.height.equalTo(pageControl.intrinsicContentSize.height)
                make.bottom.equalToSuperview().inset(4)
                make.leading.trailing.equalToSuperview()
            }

            didSetupConstraints = true
        }
        super.updateConstraints()
    }

    @objc func updatePageDisplay() {
        let index = IndexPath(item: pageControl.currentPage, section: 0)
        scrollTo(indexPath: index, animated: true)
        updateCaption?(pageControl.currentPage)
    }
}

extension PhotoGallery: UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {

    func scrollTo(indexPath: IndexPath, animated: Bool = false) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        pageControl.currentPage = indexPath.item
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return attachments.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image-cell", for: indexPath) as? ImageCollectionCell else { return UICollectionViewCell() }

        cell.imageView.kf.setImage(with: attachments[indexPath.item].url, progressBlock: { receivedSize, totalSize in
            let percentage = (CGFloat(receivedSize) / CGFloat(totalSize)) * 100.0
            cell.updatePercentage(percentage: percentage)
        })
        cell.imageView.motionIdentifier = "photo_\(attachments[indexPath.item].id!)"
        if pinchToZoom {
            cell.addPinchGesture()
            cell.captionLabel.text = attachments[indexPath.item].caption!
            cell.addCaptionConstraints()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pushToDetail?(attachments, indexPath)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = scrollView.currentPage
        updateCaption?(pageControl.currentPage)
        updateScrollPosition?(pageControl.currentPage)

    }
}

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)
    }
}
