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
import GoogleMobileAds

class ArticleStackViewController: UIViewController {

    
    let leadingOffset: CGFloat = 16
    let articleSeparatorOffset: CGFloat = 11.5
    let separatorHeight: CGFloat = 1.5
    let articleTextViewOffset: CGFloat = 7
    let shareBarHeight: CGFloat = 60
    let imageViewHeight: CGFloat = 250
    let captionTopOffset: CGFloat = 4
    let bottomInset: CGFloat = 24
    let wordCountLimit = 200

    let commentReuseIdentifier = "CommentReuseIdentifier"
    let suggestedReuseIdentifier = "SuggestedReuseIdentifier"

    var post: PostObject!
    var comments: [CommentObject]! = []
    var suggestedStories: [Int: PostObject] = [:] // map post id to post object
    var views: [UIView] = []
    var isLoadingDeeplink = false

    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var headerView: ArticleHeaderView!
    var shareBarView: ShareBarView!
    var commentsTableView: UITableView!
    var suggestedTableView: UITableView!
    
    let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

    convenience init(post: PostObject) {
        self.init()
        self.post = post
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.extendedLayoutIncludesOpaqueBars = true
        self.edgesForExtendedLayout = [.bottom]
        view.backgroundColor = darkModeEnabled ? .black : .white
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
        shareBarView.setBookmarkImage(didSelectBookmark: PostOffice.instance.isPostIdInBookmarks(post: post))
        shareBarView.delegate = self
        shareBarView.backgroundColor = darkModeEnabled ? .darkCell : .white
        view.addSubview(shareBarView)
        shareBarView.snp.makeConstraints { make in
            make.height.equalTo(shareBarHeight)
            make.bottom.width.leading.trailing.equalToSuperview()
        }
        setup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.topItem?.title = ""
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
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
            case .heading(let string):
                setupHeading(text: string)
            case .ad:
                setupAdView()
            }
        }
        setupComments()
        setupSuggestedStories()
    }

    // MARK: - Parsing HTML Tags

    func createArticleContentType(content: String) -> [ArticleContentType] {
        var sections: [ArticleContentType] = []
        guard let doc: Document = try? SwiftSoup.parse(content) else { return sections }
        guard let elements = try? doc.getAllElements() else { return sections }

        var wordCount = 0
        var swapImageAndText = false

        for i in 0..<elements.size() {
            let element = elements.array()[i]
            if element.tag().toString() == "p" {
                guard let (pItem, count, containsNestedImages) = parsePTag(element: element) else { continue }
                swapImageAndText = containsNestedImages
                // Swap image credit and caption
                if let lastItem = sections.last,
                    case ArticleContentType.imageCredit(_) = lastItem,
                    case ArticleContentType.caption(_) = pItem {
                    let lastIndex = sections.count - 1
                    sections.append(pItem)
                    sections.swapAt(lastIndex, sections.count - 1)
                } else {
                    sections.append(pItem)
                }
                wordCount += count
                // Insert ad every ~100 words
                if wordCount >= wordCountLimit {
                    sections.append(.ad)
                    wordCount = 0
                }
            } else if element.tag().toString() == "img" {
                guard let imgItem = parseImg(element: element) else { continue }
                sections.append(imgItem)
                if swapImageAndText {
                    sections.swapAt(sections.count - 1, sections.count - 2)
                }
            } else if element.tag().toString() == "aside" {
                guard let blockquote = parseAside(element: element) else { continue }
                sections.append(blockquote)
            } else if element.tag().toString() == "h2" {
                guard let heading = parseHeading(element: element) else { continue }
                sections.append(heading)
            }
        }
        return sections
    }

    /// Returns format (articleContentType, textLength, containsNestedImages)
    func parsePTag(element: Element) -> (ArticleContentType, Int, Bool)? {
        guard let text = try? element.text(), !text.isEmpty else { return nil }
        if element.hasClass("wp-media-credit") {
            return (.imageCredit(text), 0, false)
        } else if element.hasClass("wp-caption-text") {
            return (.caption(text), 0, false)
        } else {
            // replace <p> </p> with <span> </span> because of weird iOS html to string bugs
            let children = element.children().filter { $0.tag().toString() == "img" }
            let containsNestedImages = children.count > 0
            children.forEach { try? element.removeChild($0) }
            guard let openPRegex = try? NSRegularExpression(pattern: "<p[^>]*>"),
                let closePRegex = try? NSRegularExpression(pattern: "</p[^>]*>"),
                let outerHtml = try? element.outerHtml() else { return nil }

            var htmlString = openPRegex.stringByReplacingMatches(in: outerHtml, options: [], range: NSRange(location: 0, length: outerHtml.count), withTemplate: "<span style=\"font-family: '\(UIFont.articleBody.fontName)'; font-size: 18\">")
            htmlString = closePRegex.stringByReplacingMatches(in: htmlString, options: [], range: NSRange(location: 0, length: htmlString.count), withTemplate: "</span>")

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10
            let attributedString = NSMutableAttributedString(attributedString: htmlString.htmlToAttributedString ?? NSAttributedString(string: ""))
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))

            return (.text(attributedString), attributedString.string.getWordCount(), containsNestedImages)
        }
    }

    func parseImg(element: Element) -> ArticleContentType? {
        if let src = try? element.select("img[src]"), let srcString = try? src.attr("src").description, srcString != "", let srcUrl = URL(string: srcString) {
            cacheImage(imageURL: srcUrl) //cache the image
            return .image(srcString)
        }
        // slideshow parsing for now
        guard let srcString = try? element.attr("data-lazy").description, let srcUrl = URL(string: srcString) else { return nil }
        cacheImage(imageURL: srcUrl)

        return .image(srcString)
    }

    func parseAside(element: Element) -> ArticleContentType? {
        guard let text = try? element.text() else { return nil}
        if element.hasClass("module") && text != "" {
            return .blockquote(text.htmlToString)
        }
        return nil
    }

    func parseHeading(element: Element) -> ArticleContentType? {
        guard let text = try? element.text() else { return nil }
        return .heading(text)
    }

    // MARK: - Setting up subviews

    func setupCaptionLabel(caption: String) {
        let view = UIView()
        let label = UILabel()
        label.text = caption
        label.font = .photoCaption
        label.textColor = darkModeEnabled ? .white90 : .black90
        label.numberOfLines = 0
        view.addSubview(label)
        stackView.addArrangedSubview(view)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(captionTopOffset)
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
            make.bottom.equalToSuperview()
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
            make.top.equalToSuperview().offset(bottomInset)
            make.bottom.equalToSuperview()
            make.height.equalTo(imageViewHeight)
        }
    }

    func setupImageCredit(credit: String) {
        let view = UIView()
        let creditLabel = UILabel()
        creditLabel.numberOfLines = 0
        creditLabel.text = credit
        creditLabel.textColor = darkModeEnabled ? .white : .black40
        creditLabel.font = .photoCaptionCredit
        view.addSubview(creditLabel)
        stackView.addArrangedSubview(view)
        creditLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(captionTopOffset)
            make.bottom.equalToSuperview().inset(bottomInset)
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
        }
    }

    func setupArticleText(text: NSAttributedString) {
        let view = UIView()
        let textView = UITextView()
        textView.attributedText = text
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = darkModeEnabled ? .black : .white
        textView.textColor = darkModeEnabled ? .white90 : .black
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.isEditable = false
        if #available(iOS 11.0, *) {
            textView.textDragInteraction?.isEnabled = false
        }
        view.addSubview(textView)
        stackView.addArrangedSubview(view)
        textView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(articleSeparatorOffset)
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
        }
    }

    func setupBlockquote(text: String) {
        let view = UIView()
        let textView = UITextView()
        textView.text = text
        textView.textContainer.lineFragmentPadding = 0
        textView.font = .blockQuote
        textView.textColor = .black90
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

    func setupHeading(text: String) {
        let view = UIView()
        let label = UILabel()
        label.text = text
        label.font = .blockQuote
        label.textColor = .black90
        label.textAlignment = .center
        view.addSubview(label)
        stackView.addArrangedSubview(view)
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(captionTopOffset)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(leadingOffset)
        }
    }

    // MARK: - Comments

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
        commentsTableView = UITableView()
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.isScrollEnabled = false
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: commentReuseIdentifier)
        commentsTableView.estimatedRowHeight = 100
        scrollView.addSubview(commentsTableView)

        //        let totalHeight = self.comments.map { comment -> CGFloat in
        //            let textHeight = comment.comment.requiredHeight(width: view.bounds.width-37, font: .subSecondaryHeader)
        //            return textHeight + 100
        //        }
        //        stackView.snp.removeConstraints()
        //
        //        stackView.snp.remakeConstraints { make in
        //            make.leading.trailing.top.equalToSuperview()
        //            make.bottom.equalTo(commentsTableView.snp.top)
        //        }
        //
        //        commentsTableView.snp.makeConstraints { make in
        //            make.width.leading.trailing.equalToSuperview()
        //            make.height.equalTo(totalHeight.reduce(0, +))
        //            make.top.equalTo(stackView.snp.bottom)
        //            make.bottom.equalToSuperview().inset(20)
        //        }

    }

    // MARK: - Suggested Stories
    func setupSuggestedStories() {
        let headerHeight: CGFloat = 30
        let suggestedStoryPadding: CGFloat = 18
        
        let headerView = UIView()
        let headerLabel = UILabel()
        headerLabel.font = .headerTitle
        headerLabel.textColor = darkModeEnabled ? .white90 : .black90
        headerLabel.text = "Suggested Stories"
        headerView.addSubview(headerLabel)

        suggestedTableView = UITableView()
        suggestedTableView.tableHeaderView = headerView
        suggestedTableView.separatorStyle = .none
        suggestedTableView.delegate = self
        suggestedTableView.dataSource = self
        suggestedTableView.isScrollEnabled = false
        suggestedTableView.allowsSelection = false
        suggestedTableView.rowHeight = 118
        suggestedTableView.backgroundColor = darkModeEnabled ? .darkCell : .white
        suggestedTableView.tableFooterView = UIView()
        suggestedTableView.register(SuggestedStoryTableViewCell.self, forCellReuseIdentifier: suggestedReuseIdentifier)
        scrollView.addSubview(suggestedTableView)
        suggestedTableView.reloadData()

        stackView.snp.remakeConstraints { make in
            make.leading.trailing.width.top.equalToSuperview()
            make.bottom.equalTo(suggestedTableView.snp.top)
        }

        suggestedTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(CGFloat(post.suggestedStories.count * 118) + headerHeight)
            make.top.equalTo(stackView.snp.bottom)
            make.bottom.equalToSuperview().inset(suggestedStoryPadding)
        }

        headerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(headerHeight)
        }

        headerLabel.snp.makeConstraints { make in
            make.leading.equalTo(leadingOffset)
            make.height.equalTo(headerHeight)
        }

        headerView.layoutIfNeeded()
        suggestedTableView.tableHeaderView = headerView
        getSuggestedStoriesByIds()
    }

    func getSuggestedStoriesByIds() {
        getPostsFromIDs(post.suggestedStories.map { $0.postID }) { posts, error in
            if error == nil {
                self.suggestedStories = posts
                self.suggestedTableView.allowsSelection = true
            }
        }
    }

    // MARK: - Ads
    func setupAdView() {
        let imageView = GADBannerView(adSize: kGADAdSizeMediumRectangle)
        imageView.rootViewController = self
        imageView.adUnitID = "ca-app-pub-4474706420182946/7147249512"
        let view = UIView()
        view.addSubview(imageView)
        stackView.addArrangedSubview(view)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let request = GADRequest()
        //request.testDevices = [kGADSimulatorID, "0950237e30cd97ec9d147df57b7f01de"]
        imageView.load(request)
    }
}

// MARK: - TableView

extension ArticleStackViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == commentsTableView {
            return comments.count
        } else {
            return post.suggestedStories.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == commentsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: commentReuseIdentifier, for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
            cell.setup(for: comments[indexPath.row])
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: suggestedReuseIdentifier, for: indexPath) as? SuggestedStoryTableViewCell else { return UITableViewCell() }
            cell.setup(for: post.suggestedStories[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestedTableView {
            if let suggestedID = post.suggestedStories[indexPath.row].postID, let suggestedStory = suggestedStories[suggestedID] {
                let articleViewController = ArticleStackViewController(post: suggestedStory)
                navigationController?.pushViewController(articleViewController, animated: true)
            }
        }
    }

}

// MARK: - Share bar

extension ArticleStackViewController: ShareBarViewDelegate {

    func shareBarDidPressShare(_ view: ShareBarView) {
        pressedShare(entry: post)
    }

    func shareBarDidPressBookmark(_ view: ShareBarView) {
        let iconSelected: UIImage!
        let iconUnSelected: UIImage!
        
        if darkModeEnabled {
            iconSelected = UIImage(named: "bookmarkIconSelectedDark")
            iconUnSelected = UIImage(named: "bookmarkIconDark")
        } else {
            iconSelected = UIImage(named: "bookmarkIconSelectedLight")
            iconUnSelected = UIImage(named: "bookmarkIconLight")
        }
        
        let didBookmark = view.bookmarkButton.currentImage == iconUnSelected
        let correctBookmarkImage = view.bookmarkButton.currentImage == iconSelected ? iconUnSelected : iconSelected
        view.bookmarkButton.setImage(correctBookmarkImage, for: .normal)
        view.bookmarkButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        taptic(style: .light)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.4),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        view.bookmarkButton.transform = CGAffineTransform.identity
        })
        
        if didBookmark {
            PostOffice.instance.store(object: post)
        } else {
            PostOffice.instance.remove(object: post)
        }
    }
}

// MARK: - TextView

extension ArticleStackViewController: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        if !isLoadingDeeplink {
            isLoadingDeeplink.toggle()
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            getIDFromURL(URL) { id in
                guard let id = id else {
                    let safariViewController = SFSafariViewController(url: URL)
                    self.present(safariViewController, animated: true, completion: nil)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    return
                }

                getPostFromID(id, completion: { post in
                    let articleViewController = ArticleStackViewController(post: post)
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.navigationController?.pushViewController(articleViewController, animated: true)
                    self.isLoadingDeeplink.toggle()
                })
            }
        }
        return false
    }

}
