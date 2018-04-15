//
//  AdImageCell.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 2/24/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit
import GoogleMobileAds

final class AdImageCell: UICollectionViewCell, GADBannerViewDelegate {
    lazy var adImageView: GADBannerView = {
        let imageView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        imageView.rootViewController = getCurrentViewController()
        imageView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        imageView.delegate = self
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(adImageView)
        adImageView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
        }
        adImageView.load(GADRequest())
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while currentController.presentedViewController != nil {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
        
    }
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("Received ad")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed to received")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
}
