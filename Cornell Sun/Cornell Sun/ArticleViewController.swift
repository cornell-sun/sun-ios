//
//  ArticleViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 10/16/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import HTMLString

enum FontSize {
    case regular
    case large
    case small

    func getFont() -> UIFont {
        switch self {
        case .regular:
            return .articleBody
        case .large:
            return .articleBodyLarge
        case .small:
            return .articleBodySmall
        }
    }
}

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
    let articleBodyOffset: CGFloat = 25
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
    var textSizeRightBarButtonItem: UIBarButtonItem!
    var currentFontSize: FontSize = .regular

    let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    convenience init(article: PostObject) {
        self.init()
        setupWithPost(article)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        textSizeRightBarButtonItem = UIBarButtonItem(title: "Tt", style: .plain, target: self, action: #selector(toggleSize))
        navigationItem.setRightBarButton(textSizeRightBarButtonItem, animated: true)
        setupViews()
        setArticle()
        guard let tabBarControllerHeight = tabBarController?.tabBar.frame.height else { return }
        articleScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarControllerHeight, right: 0)
    }

    @objc func toggleSize() {
        switch currentFontSize {
        case .regular:
            currentFontSize = .large
        case .large:
            currentFontSize = .small
        case .small:
            currentFontSize = .regular
        }
        articleBodyTextView.font = currentFontSize.getFont()
        resizeArticleTextView()
    }

    func setupWithPost(_ post: PostObject) {
        self.post = post
    }

    func setupViews() {
        articleScrollView = UIScrollView(frame: .zero)
        articleScrollView.showsHorizontalScrollIndicator = false
        articleScrollView.isScrollEnabled = true
        view.addSubview(articleScrollView)
        articleScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.equalToSuperview()
        }

        articleView = UIView(frame: .zero)
        articleScrollView.addSubview(articleView)
        articleView.snp.makeConstraints { make in
            make.edges.width.height.equalToSuperview()
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
        titleLabel.font = .articleTitle
        titleLabel.numberOfLines = 4
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.preferredMaxLayoutWidth = view.frame.width - 2 * leadingOffset
        articleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(categoryLabel.snp.bottom).offset(titleLabelTopOffset)
        }
        titleLabel.sizeToFit()

        timeStampLabel = UILabel(frame: .zero)
        timeStampLabel.textColor = .darkGrey
        timeStampLabel.font = .author
        articleView.addSubview(timeStampLabel)
        timeStampLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(titleLabel.snp.bottom).offset(timeStampTopOffset)
            make.height.equalTo(timeStampHeight)
        }

        authorLabel = UILabel(frame: .zero)
        authorLabel.textColor = .darkGrey
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

        articleBodyTextView = UITextView(frame: .zero)
        articleBodyTextView.textColor = .blackThree
        articleBodyTextView.font = currentFontSize.getFont()
        articleBodyTextView.backgroundColor = .clear
        articleBodyTextView.isEditable = false
        articleBodyTextView.isScrollEnabled = false
        articleBodyTextView.contentSize = view.frame.size
        articleView.addSubview(articleBodyTextView)
        articleBodyTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.height.greaterThanOrEqualToSuperview()
            make.top.equalTo(heroImageView.snp.bottom).offset(articleBodyOffset)
        }
    }

    func setArticle() {
        setAuthorLabel(id: post.authorId)
        setupHeroImage()
        categoryLabel.loadtitleUsingId(post.categories)
        titleLabel.text = post.title
        timeStampLabel.text = post.datePosted.timeAgoSinceNow()
        articleBodyTextView.text = post.content
        resizeArticleTextView()
    }

    func resizeArticleTextView() {
        articleBodyTextView.sizeToFit()
        articleBodyTextView.layoutIfNeeded()
        articleView.sizeToFit()
        let height = articleBodyTextView.frame.height - imageViewHeight
        articleView.snp.remakeConstraints { make in
            make.top.width.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().offset(height)
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
