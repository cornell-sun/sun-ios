//
//  ImageCollectionCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/29/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import Foundation
import UIKit
import UICircularProgressRing

struct ImageCollectionCellConstants {

    //constraint constants
    static let loadingIndicatorHeight = 40
    static let captionHorizontalInsets = 16
    static let captionVerticalInsets = 8

    //animation constants
    static let loadingIndicatorDuration = 0.1
    static let imageTransformDuration = 0.3
}

class ImageCollectionCell: UICollectionViewCell {
    var imageView: UIImageView!
    var loadingIndicator: UICircularProgressRing!
    var captionLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true

        loadingIndicator = UICircularProgressRing()
//        loadingIndicator.ringStyle = .ontop
        loadingIndicator.innerRingWidth = 2
        loadingIndicator.outerRingWidth = 2
        loadingIndicator.innerRingColor = .brick

        captionLabel = UILabel()
        captionLabel.numberOfLines = 0
        captionLabel.textColor = .white
        captionLabel.font = .photoCaption

        contentView.addSubview(loadingIndicator)
        contentView.addSubview(imageView)
        contentView.addSubview(captionLabel)

        captionLabel.isHidden = true
        loadingIndicator.shouldShowValueText = false

        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(imageView.snp.width).dividedBy(1.5)
        }

        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(ImageCollectionCellConstants.loadingIndicatorHeight)
        }
    }

    func addCaptionConstraints() {
        captionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(ImageCollectionCellConstants.captionHorizontalInsets)
            make.top.equalTo(imageView.snp.bottom).offset(ImageCollectionCellConstants.captionHorizontalInsets)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(contentView.safeAreaLayoutGuide.snp.bottom).inset(ImageCollectionCellConstants.captionVerticalInsets)
            } else {
                make.bottom.equalToSuperview().inset(ImageCollectionCellConstants.captionVerticalInsets)
            }
        }
    }

    func addPinchGesture() {
        captionLabel.isHidden = false
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
        self.imageView.addGestureRecognizer(pinch)
    }

    @objc func didPinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            self.captionLabel.isHidden = true
            guard let view = sender.view else { return }
            let pinchCenter = CGPoint(x: sender.location(in: view).x - view.bounds.midX, y: sender.location(in: view).y - view.bounds.midY)
            let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                .scaledBy(x: sender.scale, y: sender.scale)
                .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)

            let currScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            var newScale = currScale * sender.scale

            if newScale < 1 {
                newScale = 1
                let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                self.imageView.transform = transform
            } else {
                view.transform = transform
            }

            sender.scale = 1
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            UIView.animate(withDuration: ImageCollectionCellConstants.imageTransformDuration, animations: {
                self.imageView.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.captionLabel.isHidden = false
            })
        }
    }

    func updatePercentage(percentage: CGFloat) {
        loadingIndicator.startProgress(to: percentage, duration: ImageCollectionCellConstants.loadingIndicatorDuration)
    }

    override func prepareForReuse() {
        loadingIndicator.resetProgress()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
