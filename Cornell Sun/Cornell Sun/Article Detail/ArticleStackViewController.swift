//
//  ArticleStackViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 3/18/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import SwiftSoup
import SafariServices

class ArticleStackViewController: UIViewController {

    let leadingOffset: CGFloat = 17.5
    let articleBodyOffset: CGFloat = 25
    let articleBodyInset: CGFloat = 36
    let articleSeparatorOffset: CGFloat = 15
    let separatorHeight: CGFloat = 1.5
    let articleTextViewOffset: CGFloat = 7
    let shareBarHeight: CGFloat = 50
    let imageViewHeight: CGFloat = 250
    let captionTopOffset: CGFloat = 4
    let captionBottomInset: CGFloat = 24

    let commentReuseIdentifier = "CommentReuseIdentifier"

    var post: PostObject!
    var comments: [CommentObject]! = []
    var views: [UIView] = []

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var headerView: ArticleHeaderView!
    var shareBarView: ShareBarView!
    var commentsTableView: UITableView!

    convenience init(post: PostObject) {
        self.init()
        self.post = post
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }

        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(shareBarHeight)
        }

        stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
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

        shareBarView = ShareBarView()
        shareBarView.delegate = self
        view.addSubview(shareBarView)
        shareBarView.snp.makeConstraints { make in
            make.height.equalTo(shareBarHeight)
            make.bottom.width.leading.trailing.equalToSuperview()
        }

        setup()
    }

    /// Sets up the content in the stack view by parsing each section.
    func setup() {
        let sections = createArticleContentType(content: post.content)
        for section in sections {
            switch section {
            case .caption(let caption):
                setupCaptionLabel(caption: caption)
            case .image(let urlString):
                setupImageView(imageURLString: urlString)
            case .imageCredit(let credit):
                setupImageCredit(credit: credit)
            case .text(let attrString):
                setupArticleText(text: attrString)
            case .blockquote(let string):
                setupBlockquote(text: string)
            }
        }
        setupComments()
    }

    func createArticleContentType(content: String) -> [ArticleContentType] {
        var sections: [ArticleContentType] = []
        guard let doc: Document = try? SwiftSoup.parse(content) else { return sections }
        guard let elements = try? doc.getAllElements() else { return sections }

        for element in elements {
            if element.tag().toString() == "p" {
                guard let pItem = parsePTag(element: element) else { continue }
                sections.append(pItem)
            } else if element.tag().toString() == "img" {
                guard let imgItem = parseImg(element: element) else { continue }
                sections.append(imgItem)
            } else if element.tag().toString() == "aside" {
                guard let blockquote = parseAside(element: element) else { continue }
                sections.append(blockquote)
            }
        }
        return sections
    }

    func parsePTag(element: Element) -> ArticleContentType? {
        guard let text = try? element.text() else { return nil }
        if element.hasClass("wp-media-credit") {
            return .imageCredit(text)
        } else if element.hasClass("wp-caption-text") {
            return .caption(text)
        } else {
            // replace <p> </p> with <span> </span> because of weird iOS html to string bugs
            guard let openPRegex = try? NSRegularExpression(pattern: "<p[^>]*>"),
                let closePRegex = try? NSRegularExpression(pattern: "</p[^>]*>"),
                let outerHtml = try? element.outerHtml() else { return nil }

            var htmlString = openPRegex.stringByReplacingMatches(in: outerHtml, options: [], range: NSRange(location: 0, length: outerHtml.count), withTemplate: "<span>")
            htmlString = closePRegex.stringByReplacingMatches(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.count), withTemplate: "</span>")
            return .text(htmlString.htmlToAttributedString ?? NSAttributedString(string: ""))
        }
    }

    func parseImg(element: Element) -> ArticleContentType? {
        guard let src = try? element.select("img[src]") else { return nil }
        guard let srcUrl = try? src.attr("src").description else { return nil }
        cacheImage(imageLink: srcUrl) //cache the image
        return .image(srcUrl)
    }

    func parseAside(element: Element) -> ArticleContentType? {
        guard let text = try? element.text() else { return nil}
        if element.hasClass("module") && text != "" {
            return .blockquote(text.htmlToString)
        }
        return nil
    }

    func setupCaptionLabel(caption: String) {
        let view = UIView()
        let label = UILabel()
        label.text = caption
        label.font = .photoCaption
        label.textColor = .black90
        label.numberOfLines = 0
        view.addSubview(label)
        stackView.addArrangedSubview(view)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.bottom.equalToSuperview().inset(captionBottomInset)
        }
    }

    func setupImageView(imageURLString: String) {
        let view = UIView()
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: URL(string: imageURLString))
        view.addSubview(imageView)
        stackView.addArrangedSubview(view)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(captionBottomInset)
            make.bottom.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }
    }

    func setupImageCredit(credit: String) {
        let view = UIView()
        let creditLabel = UILabel()
        creditLabel.numberOfLines = 0
        creditLabel.text = credit
        creditLabel.textColor = .black40
        creditLabel.font = .photoCaptionCredit
        view.addSubview(creditLabel)
        stackView.addArrangedSubview(view)
        creditLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(captionTopOffset)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
        }
    }

    func setupArticleText(text: NSAttributedString) {
        let view = UIView()
        let textView = UITextView()
        textView.attributedText = text
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .articleBody
        textView.textColor = .black
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isEditable = false
        if #available(iOS 11.0, *) {
            textView.textDragInteraction?.isEnabled = false
        }
        view.addSubview(textView)
        stackView.addArrangedSubview(view)
        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
        }
    }

    func setupBlockquote(text: String) {
        let view = UIView()
        let textView = UITextView()
        textView.text = text
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .blockQuote
        textView.textColor = .black
        textView.textAlignment = .left
        textView.isScrollEnabled = false
        textView.isEditable = false
        if #available(iOS 11.0, *) {
            textView.textDragInteraction?.isEnabled = false
        }
        view.addSubview(textView)
        let leftLine = UILabel()
        leftLine.backgroundColor = .black
        view.addSubview(leftLine)
        stackView.addArrangedSubview(view)
        leftLine.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(leadingOffset)
            make.top.bottom.equalToSuperview().inset(leadingOffset)
            make.width.equalTo(1)
        }
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(leadingOffset)
            make.leading.equalTo(leftLine.snp.trailing).offset(leadingOffset)
            make.trailing.equalToSuperview().inset(leadingOffset)
            make.bottom.equalToSuperview().offset(-leadingOffset)
        }
    }

    func setupComments() {
        getComments(postID: post.id) { comments, error in
            if error == nil {
                self.comments = comments
                self.setupCommentsTableView()
                self.commentsTableView.reloadData()
            }
        }
    }

    func setupCommentsTableView() {
//        let view = UIView()
        commentsTableView = UITableView()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.isScrollEnabled = false
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: commentReuseIdentifier)
        commentsTableView.estimatedRowHeight = 100
        scrollView.addSubview(commentsTableView)
//        stackView.addArrangedSubview(view)

        let totalHeight = self.comments.map { comment -> CGFloat in

            let textHeight = comment.comment.requiredHeight(width: view.bounds.width-37, font: .subSecondaryHeader)
            return textHeight + 100
        }

        stackView.snp.removeConstraints()

        stackView.snp.remakeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(commentsTableView.snp.top)
        }

        commentsTableView.snp.makeConstraints { make in
            make.width.leading.trailing.equalToSuperview()
            make.height.equalTo(totalHeight.reduce(0, +))
            make.top.equalTo(stackView.snp.bottom)
            make.bottom.equalToSuperview().inset(20)
        }

    }
}

extension ArticleStackViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: commentReuseIdentifier, for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell() }
        cell.setup(for: comments[indexPath.row])
        return cell
    }

}

extension ArticleStackViewController: ShareBarViewDelegate {

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
                       usingSpringWithDamping: CGFloat(0.4),
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

extension ArticleStackViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        let safariViewController = SFSafariViewController(url: URL)
        present(safariViewController, animated: true, completion: nil) // TODO: detect if it's a Sun article and display that article instead
        return false
    }

}
