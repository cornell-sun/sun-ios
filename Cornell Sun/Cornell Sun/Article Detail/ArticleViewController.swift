//
//  ArticleViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 10/16/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import HTMLString
import SafariServices

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
    let articleBodyOffset: CGFloat = 25
    let articleBodyInset: CGFloat = 36
    let articleSeparatorOffset: CGFloat = 15
    let separatorHeight: CGFloat = 1.5
    let articleTextViewOffset: CGFloat = 7
    let shareBarHeight: CGFloat = 50
    let commentReuseIdentifier = "CommentReuseIdentifier"

    var post: PostObject!
    var comments: [CommentObject]! = []

    // UI Components
    var articleScrollView: UIScrollView!
    var articleView: UIView!
    var articleHeaderView: ArticleHeaderView!
    var articleBodyTextView: UITextView!
    var textSizeRightBarButtonItem: UIBarButtonItem!
    var commentsLabel: UILabel!
    var commentsTableView: UITableView!
    var articleEndSeparator: UILabel!
    var shareBarView: ShareBarView!

    var currentFontSize: FontSize = .regular

    let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    convenience init(article: PostObject) {
        self.init()
        self.post = article
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        textSizeRightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "textSize"), style: .plain, target: self, action: #selector(toggleSize))
        navigationItem.setRightBarButton(textSizeRightBarButtonItem, animated: true)
        setupViews()
        setupWithArticle()
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
    }

    func setupViews() {
        articleScrollView = UIScrollView()
        guard let tabBarControllerHeight = tabBarController?.tabBar.frame.height else { return }
        articleScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tabBarControllerHeight, right: 0)
        view.addSubview(articleScrollView)
        articleScrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets.zero)
        }

        articleView = UIView()
        articleScrollView.addSubview(articleView)
        articleView.snp.makeConstraints { make in
            make.edges.equalTo(articleScrollView).inset(UIEdgeInsets.zero)
            make.width.equalTo(articleScrollView)
        }

        articleHeaderView = ArticleHeaderView(article: post, frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        articleView.addSubview(articleHeaderView)
        articleHeaderView.snp.makeConstraints { make in
            make.leading.trailing.width.top.equalToSuperview()
        }

        commentsLabel = UILabel(frame: .zero)
        commentsLabel.text = "Comments"
        commentsLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        commentsLabel.textColor = .black
        articleView.addSubview(commentsLabel)

        articleEndSeparator = UILabel(frame: .zero)
        articleEndSeparator.backgroundColor = .warmGrey
        articleView.addSubview(articleEndSeparator)

        commentsTableView = UITableView(frame: .zero)
        articleView.addSubview(commentsTableView)
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: commentReuseIdentifier)
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.tableFooterView = UIView()
        commentsTableView.isScrollEnabled = false
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        commentsTableView.estimatedRowHeight = 150

        articleBodyTextView = UITextView(frame: .zero)
        articleBodyTextView.isEditable = false
        articleBodyTextView.textContainer.lineFragmentPadding = 0
        articleBodyTextView.font = currentFontSize.getFont()
        articleBodyTextView.delegate = self
        articleBodyTextView.isScrollEnabled = false
        if #available(iOS 11.0, *) {
            articleBodyTextView.textDragInteraction?.isEnabled = false
        }
        articleBodyTextView.linkTextAttributes = [
            NSAttributedStringKey.foregroundColor.rawValue: UIColor.lightBlue,
            NSAttributedStringKey.underlineColor.rawValue: UIColor.clear
        ]
        articleView.addSubview(articleBodyTextView)
        articleBodyTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.top.equalTo(articleHeaderView.snp.bottom).offset(articleTextViewOffset)
            make.bottom.equalTo(articleEndSeparator.snp.top)
        }

        articleEndSeparator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.height.equalTo(separatorHeight)
            make.top.equalTo(articleBodyTextView.snp.bottom)
        }

        commentsLabel.snp.makeConstraints { make in
            make.top.equalTo(articleEndSeparator.snp.bottom).offset(articleSeparatorOffset)
            make.leading.equalToSuperview().offset(leadingOffset)
        }

        shareBarView = ShareBarView()
        shareBarView.delegate = self
        view.addSubview(shareBarView)
        shareBarView.snp.makeConstraints { make in
            make.height.equalTo(shareBarHeight)
            make.bottom.width.leading.trailing.equalToSuperview()
        }

    }

    func setupWithArticle() {
        // how to insert images into text
        let paragraphStyle = NSMutableParagraphStyle()
        let content = post.attributedContentString()
        let attrContent = NSMutableAttributedString(attributedString: content)
        attrContent.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: content.length))
        articleBodyTextView.attributedText = attrContent
        articleBodyTextView.setNeedsUpdateConstraints()

        shareBarView.bookmarkButton.setImage(post.didSave ? #imageLiteral(resourceName: "bookmarkPressed") : #imageLiteral(resourceName: "bookmark"), for: .normal)
        // hardcoded comments
        let comment1 = CommentObject(id: 0, postId: 0, authorName: "Brendan Elliott", comment: "Great Story! I really enjoyed reading about the perserverance of the current candidate, despite the stressful election.", date: Date(), image: #imageLiteral(resourceName: "brendan"))
        let comment2 = CommentObject(id: 0, postId: 0, authorName: "Hettie Coleman", comment: "This story was wack! But I will be respectful because that’s how online discourse should be!", date: Date(), image: #imageLiteral(resourceName: "emptyProfile"))
        comments.append(comment1)
        comments.append(comment2)
        commentsTableView.reloadData()

        commentsTableView.snp.makeConstraints { make in
            make.width.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(commentsLabel.snp.bottom).offset(articleSeparatorOffset)
            make.height.equalTo(commentsTableView.contentSize.height)
        }
    }
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: commentReuseIdentifier, for: indexPath) as? CommentTableViewCell ?? CommentTableViewCell()
        let comment = comments[indexPath.row]
        cell.setup(for: comment)
        return cell
    }

}

extension ArticleViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariVC = SFSafariViewController(url: URL)
        present(safariVC, animated: true, completion: nil) // TODO: detect if it's a Sun article and display that article instead
        return false
    }

}

extension ArticleViewController: ShareBarViewDelegate {

    func shareBarDidPressShare(_ view: ShareBarView) {
        taptic(style: .light)
        if let articleLink = URL(string: post.link) {
            let title = post.title
            let objectToShare = [title, articleLink] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
        }
    }

    func shareBarDidPressBookmark(_ view: ShareBarView) {
        let didBookmark = view.bookmarkButton.currentImage == #imageLiteral(resourceName: "bookmark")
        let correctBookmarkImage = view.bookmarkButton.currentImage == #imageLiteral(resourceName: "bookmarkPressed") ? #imageLiteral(resourceName: "bookmark") : #imageLiteral(resourceName: "bookmarkPressed")
        view.bookmarkButton.setImage(correctBookmarkImage, for: .normal)
        view.bookmarkButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        taptic(style: .light)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.40),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        view.bookmarkButton.transform = CGAffineTransform.identity
        })
        if didBookmark {
            RealmManager.instance.save(object: post)
        } else {
            RealmManager.instance.delete(object: post)
        }
    }

}
