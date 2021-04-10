//
//  AuthorDetailViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/10/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import IGListKit
import SnapKit
import UIKit

class AuthorDetailViewController: UIViewController, UIScrollViewDelegate {

    // MARK: View vars
    let spinToken = "spinner"
    let authorSwitchTitleClosed = "Choose Author ▼"
    let authorSwitchTitleOpened = "Choose Author ▲"
    
    private var loading = true
    private var hasNextPage = true
    private var currentPage = 1

    var adapter: ListAdapter!
    var authorSelect: AuthorSelectView!
    var authorSelectTopDown: Constraint!
    var authorSelectTopUp: Constraint!
    var authorSelectViewExtended = false
    var authorSwitchButton: UIButton!
    var collectionView: UICollectionView!
    var selectedAuthor = 0
    var tintView = UIView()

    // MARK: Data vars
    var authors: [AuthorObject] = []

    init(authors: [AuthorObject]) {
        self.authors = authors
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = darkModeEnabled ? .white : .black

        if authors.count > 1 {
            authorSwitchButton = UIButton()
            authorSwitchButton.setTitle(authorSwitchTitleClosed, for: .normal)
            authorSwitchButton.setTitleColor(.black, for: .normal)
            authorSwitchButton.showsTouchWhenHighlighted = false
            authorSwitchButton.adjustsImageWhenHighlighted = false
            authorSwitchButton.titleLabel?.textColor = .black
            authorSwitchButton.titleLabel?.font = .avenir18
            authorSwitchButton.addTarget(self, action: #selector(showHideAuthorSelect), for: .touchUpInside)
            navigationItem.titleView = authorSwitchButton
        }

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .lightGray2
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.snp.top)
        }

        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        tintView.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        view.addSubview(tintView)
        tintView.isHidden = true
        tintView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        authorSelect = AuthorSelectView(authorNames: self.authors.map { $0.name })
        authorSelect.delegate = self
        view.addSubview(authorSelect)
        authorSelect.layer.cornerRadius = authorSelect.getHeight() / 7.0
        authorSelect.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        authorSelect.snp.makeConstraints { make in
            make.height.equalTo(authorSelect.getHeight())
            make.leading.trailing.equalToSuperview()
            authorSelectTopUp = make.top.equalToSuperview().offset(-authorSelect.getHeight()).constraint
            authorSelectTopDown = make.top.equalToSuperview().constraint
        }
        authorSelectTopDown.deactivate()
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(showHideAuthorSelect))
        swipeUpGesture.direction = .up
        authorSelect.addGestureRecognizer(swipeUpGesture)
        authorSelect.isUserInteractionEnabled = true

        authors.enumerated().forEach { i, author in
            getAuthorInfo(authorName: author.name, authorIndex: i)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func showHideAuthorSelect() {
        if authorSelectViewExtended {
            authorSwitchButton.setTitle(authorSwitchTitleClosed, for: .normal)
            navigationItem.titleView = authorSwitchButton
            UIView.animate(withDuration: 0.2, animations: {
                self.tintView.isHidden = true
                self.authorSelectTopDown.deactivate()
                self.authorSelectTopUp.activate()
                self.view.layoutIfNeeded()
            })
        } else {
            authorSwitchButton.setTitle(authorSwitchTitleOpened, for: .normal)
            navigationItem.titleView = authorSwitchButton
            UIView.animate(withDuration: 0.2, animations: {
                self.tintView.isHidden = false
                self.authorSelectTopUp.deactivate()
                self.authorSelectTopDown.activate()
                self.view.layoutIfNeeded()
            })
        }
        authorSelectViewExtended.toggle()
    }

    // MARK: Networking
    private func getAuthorPosts(for author: AuthorObject) {
        self.loading = true
        self.adapter.performUpdates(animated: true, completion: nil)
        API.request(target: .postsFor(authorName: author.name, page: author.postsPage + 1)) { response in
            if let response = response {
                do {
                    let newPosts = try decoder.decode(AuthorObject.self, from: response.data).posts
                    
                    if (newPosts!.isEmpty) {
                        self.hasNextPage = false
                    }
                    
                    if let posts = author.posts {
                        author.posts = posts + (newPosts ?? [])
                    } else {
                        author.posts = newPosts
                    }
                    author.postsPage += 1
                    self.networkRequestEnded()
                    //postObjects.insert("adToken" as ListDiffable, at: 7)
                } catch let error {
                    print("Error decoding author object: \(error)")
                    self.networkRequestEnded()
                    return
                }
            } else {
                print("Error fetching author object")
                self.networkRequestEnded()
                return
            }
        }
    }

    private func getAuthorInfo(authorName: String, authorIndex: Int) {
        self.loading = true
        self.adapter.performUpdates(animated: true, completion: nil)
        API.request(target: .author(authorName: authorName)) { response in
            if let response = response {
                do {
                    let authorInfo = try decoder.decode(AuthorObject.self, from: response.data)
                    self.authors[authorIndex] = authorInfo
                    self.authors[authorIndex].postsPage = 1
                    self.networkRequestEnded()
                    //postObjects.insert("adToken" as ListDiffable, at: 7)
                } catch let error {
                    print("Error decoding author object: \(error)")
                    self.networkRequestEnded()
                    return
                }
            } else {
                print("Error fetching author object")
                self.networkRequestEnded()
                return
            }
        }
    }

    func networkRequestEnded() {
        self.loading = false
        self.adapter.performUpdates(animated: true, completion: nil)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 300 && hasNextPage {
            getAuthorPosts(for: authors[selectedAuthor])
        }
    }
}

// MARK: - IGListKit
extension AuthorDetailViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let author = authors[selectedAuthor]
        let authorDetail = AuthorDetailObject(
            bio: author.bio,
            email: author.email,
            imageURL: author.avatarURL,
            linkedIn: author.linkedin,
            name: author.name,
            twitter: author.twitter
        )

        var objects: [ListDiffable] = [authorDetail] + (authors[selectedAuthor].posts ?? [])

        if loading {
            objects.append(spinToken as ListDiffable)
        }
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? AuthorDetailObject {
            return AuthorDetailSectionController(authorDetail: obj, screenWidth: view.bounds.width)
        } else if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else if let obj = object as? PostObject, obj.postType == .photoGallery {
            return PhotoGallerySectionController()
        }
        
        let bookmarkSC = BookmarkSearchSectionController(forBookmarks: false)
        bookmarkSC.delegate = self
        return bookmarkSC
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

// MARK: - TabBarViewControllerDelegate
extension AuthorDetailViewController: TabBarViewControllerDelegate {

    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleStackViewController(post: article)
        navigationController?.pushViewController(articleVC, animated: true)
    }

}

extension AuthorDetailViewController: AuthorSelectViewDelegate {

    func authorIndexChanged(to index: Int) {
        selectedAuthor = index
        showHideAuthorSelect()
        self.adapter.performUpdates(animated: true, completion: nil)
    }

}
