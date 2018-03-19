//
//  ArticleStackViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 3/18/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class ArticleStackViewController: UIViewController {

    let leadingOffset: CGFloat = 17.5
    let articleBodyOffset: CGFloat = 25
    let articleBodyInset: CGFloat = 36
    let articleSeparatorOffset: CGFloat = 15
    let separatorHeight: CGFloat = 1.5
    let articleTextViewOffset: CGFloat = 7
    let shareBarHeight: CGFloat = 50
    let commentReuseIdentifier = "CommentReuseIdentifier"

    var post: PostObject!
    var comments: [CommentObject]! = []

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var headerView: ArticleHeaderView!

    convenience init(post: PostObject) {
        self.init()
        self.post = post
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        headerView = ArticleHeaderView(article: post, frame: .zero)
        stackView.addArrangedSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
        }

    }

    func setup() {
        // try setting up multiple views and splitting into array, then setting up views
    }

}
