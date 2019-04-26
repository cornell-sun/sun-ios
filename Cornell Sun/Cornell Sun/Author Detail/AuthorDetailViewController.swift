//
//  AuthorDetailViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/10/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import IGListKit
import UIKit

class AuthorDetailViewController: UIViewController, UIScrollViewDelegate {

    // MARK: View vars
    var adapter: ListAdapter!
    var collectionView: UICollectionView!
    let spinToken = "spinner"
    private var loading = true
    private var currentPage = 1

    // MARK: Data vars
    var author: AuthorObject
    var posts: [PostObject] = []
    private let authorID: Int

    init(author: AuthorObject, authorID: Int) {
        self.author = author
        self.authorID = authorID
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Writer Page"

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .lightGray2
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        getAuthorPosts(page: currentPage)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Networking
    private func getAuthorPosts(page: Int) {
        API.request(target: .postsFor(authorID: authorID, page: page)) { response in
            if let response = response {
                do {
                    let newPosts = try decoder.decode([PostObject].self, from: response.data)
                    self.posts.append(contentsOf: newPosts)
                    self.loading = false
                    self.adapter.performUpdates(animated: true, completion: nil)
                    //postObjects.insert("adToken" as ListDiffable, at: 7)
                } catch let error {
                    print(error)
                    return
                }
            }
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 300 {
            loading = true
            adapter.performUpdates(animated: true, completion: nil)
            currentPage += 1
            getAuthorPosts(page: currentPage)
        }
    }
}

// MARK: - IGListKit
extension AuthorDetailViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let authorDetail = AuthorDetailObject(bio: author.bio, email: author.email, imageURL: author.avatarURL, linkedIn: author.linkedin, name: author.name, twitter: author.twitter)

        var objects: [ListDiffable] = [authorDetail] + posts

        if loading {
            objects.append(spinToken as ListDiffable)
        }
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? AuthorDetailObject {
            return AuthorDetailSectionController(authorDetail: obj)
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
