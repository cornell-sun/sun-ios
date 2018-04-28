//
//  VideoCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/26/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import SnapKit
import Kingfisher

final class VideoCell: UICollectionViewCell {

    var post: PostObject? {
        didSet {
            setupVideo()
        }
    }

    let videoWebView: UIWebView = {
        let webView = UIWebView()
        webView.allowsInlineMediaPlayback = true
        webView.backgroundColor = .orange
        return webView
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
        addSubview(videoWebView)
        videoWebView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
    }

    func setupVideo() {
        if let videoUrl = post?.postAttachments[0].url {
            let request = URLRequest(url: videoUrl)
            videoWebView.loadRequest(request)
            //videoWebView.loadHTMLString("<body style=\"margin: 0; padding: 0;\"><iframe width=\"\(videoWebView.frame.width)\" height=\"\(videoWebView.frame.height)\" src=\"\(videoUrl)?&playsinline=1\" frameborder=\"0\" allowfullscreen></iframe></body>", baseURL: nil)
        }
    }
}
