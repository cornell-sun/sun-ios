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

class PhotoGallery: UIView {

    private var didSetupConstraints = false
    private var didSetupImages = false
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    private var attachments: [PostAttachmentObject]!
    fileprivate var selectedIndex: IndexPath!
    fileprivate var height: CGFloat!
    fileprivate var width: CGFloat!

    var updateCaption: ((Int) -> Void)?

    init(attachments: [PostAttachmentObject], height: CGFloat, width: CGFloat) {
        super.init(frame: .zero)

        self.attachments = attachments
        self.height = height
        self.width = width

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .lightGray2
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "image-cell")

        pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = attachments.count

        addSubview(collectionView)
        addSubview(pageControl)
        self.setNeedsUpdateConstraints()

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
}

class ImageCollectionCell: UICollectionViewCell {
    var imageView: UIImageView!
    var loadingIndicator: UICircularProgressRingView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        imageView.backgroundColor = .clear
        loadingIndicator = UICircularProgressRingView()
        loadingIndicator.ringStyle = .ontop
        loadingIndicator.innerRingWidth = 2
        loadingIndicator.outerRingWidth = 2
        loadingIndicator.innerRingColor = .brick

        contentView.addSubview(loadingIndicator)
        contentView.addSubview(imageView)

        loadingIndicator.shouldShowValueText = false

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(40)
        }
    }

    func updatePercentage(percentage: CGFloat) {
        loadingIndicator.setProgress(to: percentage, duration: 0.1)
    }

    override func prepareForReuse() {
        loadingIndicator.setProgress(to: 0.0, duration: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PhotoGallery: UICollectionViewDataSource, UICollectionViewDelegate {

    func scrollTo(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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
    return cell
}

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("push to detail")
    }

func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pageControl.currentPage = scrollView.currentPage
    updateCaption?(pageControl.currentPage)

}
}

extension UIScrollView {
    var currentPage: Int {
        return Int((self.contentOffset.x + (0.5*self.frame.size.width))/self.frame.width)
    }
}

extension PhotoGallery: ZoomingViewController {
    func zoomingImageView(for transition: ZoomTransitioningDelegate) -> UIImageView? {
        guard let indexPath = selectedIndex else { return nil }
        guard let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionCell else { return nil}
        return cell.imageView
    }

    func zoomingBackgroundView(for transition: ZoomTransitioningDelegate) -> UIView? {
        return nil
    }
}
