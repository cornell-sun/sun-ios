//
//  ViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/20/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var activityIndicatorBackgroundView: UIView!
    var activityIndicatorView: UIActivityIndicatorView?

    private let activityIndicatorCornerRadius: CGFloat = 8
    private let activityIndicatorHeight: CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        navigationItem.title = "The Cornell Daily Sun"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 30)!
        ]

        activityIndicatorBackgroundView = UIView()
        activityIndicatorBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        activityIndicatorBackgroundView.layer.cornerRadius = activityIndicatorCornerRadius
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "The Cornell Daily Sun"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 30)!
        ]
    }

    func startAnimating() {
        view.addSubview(activityIndicatorBackgroundView)
        activityIndicatorBackgroundView.snp.makeConstraints { make in
            make.width.height.equalTo(activityIndicatorHeight)
            make.center.equalToSuperview()
        }

        activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        view.addSubview(activityIndicatorView!)
        activityIndicatorView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        activityIndicatorView?.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
    }

}
