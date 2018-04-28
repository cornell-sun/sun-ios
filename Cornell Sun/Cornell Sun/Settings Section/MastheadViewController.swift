//
//  MastheadViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/28/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class MastheadViewController: UIViewController {

    var scrollView: UIScrollView!
    var imageView: UIImageView!
    var imageURL: URL!

    init(url: URL) {
        imageURL = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView = UIImageView()
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.kf.setImage(with: imageURL)
    }

}
