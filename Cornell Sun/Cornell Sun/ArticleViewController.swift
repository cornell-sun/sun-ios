//
//  ArticleViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 10/16/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import HTMLString

class ArticleViewController: UIViewController {
    let leadingOffset: CGFloat = 17.5
    let categoryLabelTopOffset: CGFloat = 18.5
    let categoryLabelHeight: CGFloat = 18
    let titleLabelTopOffset: CGFloat = 12.0
    let titleLabelHeight: CGFloat = 100
    let imageViewHeight: CGFloat = 250.0
    let imageViewTopOffset: CGFloat = 12.0
    let timeStampTopOffset: CGFloat = 14.5
    let timeStampHeight: CGFloat = 14
    let authorLabelHeight: CGFloat = 14
    let articleBodyOffset: CGFloat = 43.5
    let articleBodyInset: CGFloat = 36

    var post: PostObject!

    // UI Components
    var articleScrollView: UIScrollView!
    var articleView: UIView!
    var categoryLabel: CategoryLabel!
    var titleLabel: UILabel!
    var authorLabel: UILabel!
    var timeStampLabel: UILabel!
    var captionLabel: UILabel!
    var articleBodyTextView: UITextView!

    let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    fileprivate let activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        //view.startAnimating()
        return view
    }()

    convenience init(article: PostObject) {
        self.init()
        setupWithPost(article)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteTwo
        setupViews()
        setArticle()
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupWithPost(_ post: PostObject) {
        self.post = post
    }

    func setupViews() {
        articleScrollView = UIScrollView(frame: view.frame)
        articleScrollView.showsHorizontalScrollIndicator = false
        articleScrollView.isScrollEnabled = true
        view.addSubview(articleScrollView)
        articleScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        articleView = UIView(frame: view.frame)
        articleScrollView.addSubview(articleView)
        articleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        categoryLabel = CategoryLabel(frame: .zero)
        categoryLabel.textColor = .black
        categoryLabel.font = .articleViewTheme
        articleView.addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingOffset)
            make.top.equalToSuperview().offset(categoryLabelTopOffset)
            make.height.equalTo(categoryLabelHeight)
        }

        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = .blackThree
        titleLabel.font = .articleViewTitle
        titleLabel.numberOfLines = 3
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.preferredMaxLayoutWidth = view.frame.width - 2 * leadingOffset
        articleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(categoryLabel.snp.bottom).offset(titleLabelTopOffset)
//            make.height.equalTo(titleLabelHeight)
        }
        titleLabel.sizeToFit()

        timeStampLabel = UILabel(frame: .zero)
        timeStampLabel.textColor = .warmGrey
        timeStampLabel.font = .author
        articleView.addSubview(timeStampLabel)
        timeStampLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(titleLabel.snp.bottom).offset(timeStampTopOffset)
            make.height.equalTo(timeStampHeight)
        }

        authorLabel = UILabel(frame: .zero)
        authorLabel.textColor = .warmGrey
        authorLabel.font = .author
        articleView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingOffset)
            make.bottom.equalTo(timeStampLabel.snp.bottom)
            make.height.equalTo(authorLabelHeight)
        }

        articleView.addSubview(heroImageView)
        heroImageView.snp.makeConstraints { make in
            make.top.equalTo(timeStampLabel.snp.bottom).offset(imageViewTopOffset)
            make.width.leading.centerX.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }

        articleBodyTextView = UITextView()
        articleBodyTextView.textColor = .blackThree
        articleBodyTextView.font = .articleBody
        articleBodyTextView.backgroundColor = .clear
        articleBodyTextView.isEditable = false
        articleBodyTextView.isScrollEnabled = false
        articleBodyTextView.contentSize = view.frame.size
        articleView.addSubview(articleBodyTextView)
        articleBodyTextView.snp.makeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(articleBodyOffset)
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.height.equalToSuperview()
        }
    }

    func setArticle() {
        setAuthorLabel(id: post.authorId)
        setupHeroImage()
        categoryLabel.loadtitleUsingId(post.categories)
        titleLabel.text = post.title
        articleBodyTextView.text = post.content
        articleBodyTextView.sizeToFit()
        timeStampLabel.text = post.datePosted.timeAgoSinceNow()

        articleBodyTextView.snp.remakeConstraints { make in
            make.top.equalTo(heroImageView.snp.bottom).offset(articleBodyOffset)
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.height.equalToSuperview()
        }

        articleView.snp.remakeConstraints { make in
            make.height.equalToSuperview().multipliedBy(5) // need to resize to fit textview
            make.top.width.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(articleBodyInset)
        }

    }

    func setAuthorLabel(id: Int) {
        API.request(target: .author(authorId: id)) { response in
            guard let response = response else { return }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: []) as? NSDictionary,
                    let author = AuthorObject.from(jsonResult) {
                    self.authorLabel.text = "By \(author.name.removingHTMLEntities.htmlToString)"
                }
            } catch {
                print("Could not parse author")
            }
        }
    }

    func setupHeroImage() {
        if let heroImageUrl = URL(string: post.mediaLink) {
            heroImageView.kf.indicatorType = .activity
            heroImageView.kf.setImage(with: heroImageUrl)
        }
    }

}
