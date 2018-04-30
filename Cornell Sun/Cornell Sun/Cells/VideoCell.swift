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
        return webView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(videoWebView)
        videoWebView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
        }
    }

    func setupVideo() {
        if let videoUrl = post?.postAttachments[0].url {
            let request = URLRequest(url: videoUrl)
            videoWebView.loadRequest(request)

        }
    }
}
