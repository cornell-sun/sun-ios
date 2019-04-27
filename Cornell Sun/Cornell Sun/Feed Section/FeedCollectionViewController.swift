//
//  FeedCollectionViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/3/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

class FeedCollectionViewController: ViewController, UIScrollViewDelegate {
    var loading = false

    fileprivate var observer: NSKeyValueObservation?

    var currentPage = 1
    let spinToken = "spinner"
    var adIndex = 7
    var adCount = 1
    var adDict = [String: Int]()
    var currAdToken = ""

    var bookmarkPosts: [PostObject] = {
        return PostOffice.instance.get() ?? []
    }()

    var feedData: [ListDiffable] = []
    var headlinePost: PostObject!
    var isFirstRun = true

    var refreshControl = UIRefreshControl()

    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        return view
    }()

    lazy var adapter: ListAdapter  = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationInformation()
        guard !isFirstRun else {
            isFirstRun = false
            return
        }

        self.adapter.performUpdates(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        observer = PostOffice.instance.observe(\.packages, options: [.initial, .new]) { (postOffice, change) in
            if let newValue = change.newValue {
                self.bookmarkPosts = newValue
            } else {
                self.bookmarkPosts = postOffice.packages
            }
            self.updateBookmarksInFeed()
            self.adapter.performUpdates(animated: true, completion: nil)
        }

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        view.addSubview(collectionView)

        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = .black5
        adapter.collectionView?.refreshControl = refreshControl
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    deinit {
        observer?.invalidate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func isPostIdInBookmarks(post: PostObject, currListOfBookmarks: [PostObject]) -> PostObject? {
        guard let index = currListOfBookmarks.index(where: {$0.id == post.id}) else { return nil }
        return currListOfBookmarks[index]
    }

    fileprivate func updateBookmarksInFeed() {
        let currListOfBookmarks = bookmarkPosts
        feedData = feedData.map { postObj in
            guard let post = postObj as? PostObject else { return postObj }
            guard let updatedBookmarkPost = isPostIdInBookmarks(post: post, currListOfBookmarks: currListOfBookmarks) else { return post }
            return updatedBookmarkPost
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 300 {
            loading = true
            adapter.performUpdates(animated: true, completion: nil)
            currentPage += 1
            getPosts(page: currentPage)
        }
    }
}

extension FeedCollectionViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects = feedData as [ListDiffable]

        if let mainPost = headlinePost {
            objects = [mainPost] + objects
        }

        if loading {
            objects.append(spinToken as ListDiffable)
        }
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else if let obj = object as? PostObject, obj.isEqual(toDiffableObject: headlinePost) {
            let heroSC = HeroSectionController()
            heroSC.delegate = self
            return heroSC
        } else if let obj = object as? PostObject, obj.postType == .photoGallery {
            return PhotoGallerySectionController()
        } else if let obj = object as? String, obj.contains("adToken") {
            return AdSectionController()
        }
        let articleSC = ArticleSectionController()
        articleSC.delegate = self
        return articleSC
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}

extension FeedCollectionViewController {

    func getPosts(page: Int) {

        fetchPosts(target: .posts(page: page)) { posts, error in
            if error == nil {
                var postsWithAd: [ListDiffable] = posts
                postsWithAd.insert("adToken\(self.adCount)" as ListDiffable, at: 7)
                self.adCount += 1
                self.loading = false
                self.feedData.append(contentsOf: postsWithAd)
                self.refreshControl.endRefreshing()
                self.updateBookmarksInFeed()
                self.adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }

    @objc func refreshData() {
        currentPage = 1
        feedData = []
        getPosts(page: currentPage)
    }

    func setNavigationInformation() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 30)!]
        navigationItem.title = "The Cornell Daily Sun"
    }
}

extension FeedCollectionViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleStackViewController(post: article)
        
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
