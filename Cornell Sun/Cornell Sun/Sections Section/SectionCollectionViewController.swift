//
//  SectionCollectionViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 2/12/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

class SectionCollectionViewController: UIViewController, UIScrollViewDelegate {

    fileprivate var observer: NSKeyValueObservation?

    var sectionSelected: Sections!
    var emptySpinnerView = UIView()
    let spinner = UIActivityIndicatorView(style: .gray)
    var refreshControl = UIRefreshControl()
    var bookmarkPosts: [PostObject] = []
    var feedData: [ListDiffable] = [] {
        didSet {
            if feedData.isEmpty {
                spinner.startAnimating()
            } else {
                spinner.stopAnimating()
            }
        }
    }
    var loading = false
    var currentPage = 1
    var adCount = 1
    var sectionID = 0
    let spinToken = "spinner"
    var sectionTitle = ""

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        return view
    }()

    lazy var adapter: ListAdapter  = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    init(with section: Sections, sectionTitle: String) {
        super.init(nibName: nil, bundle: nil)
        sectionSelected = section
        self.sectionTitle = sectionTitle
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.headerTitle
        ]

        switch section {
        case .news(let id), .opinion(let id), .arts(let id), .dining(let id), .multimedia(let id), .science(let id), .sports(let id):
            sectionID = id
        }

        getPosts(page: currentPage, sectionID: sectionID)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        observer = nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.topItem?.title = ""

        emptySpinnerView.addSubview(spinner)

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
        adapter.collectionView?.backgroundColor = darkModeEnabled ? .black : .collectionBackground
        adapter.collectionView?.refreshControl = refreshControl
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        updateColors()
    }
    
    func updateColors() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        refreshControl.tintColor = darkModeEnabled ? .white : .black
        navigationItem.backBarButtonItem?.tintColor = darkModeEnabled ? .white : .black
        navigationController?.navigationBar.barTintColor = darkModeEnabled ? .darkTint : .white
        navigationController?.navigationBar.barStyle = darkModeEnabled ? .blackTranslucent : .default
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.headerTitle, NSAttributedString.Key.foregroundColor: darkModeEnabled ? UIColor.white : UIColor.black
        ]
        refreshControl.tintColor = darkModeEnabled ? .white : .black
        adapter.collectionView?.backgroundColor = darkModeEnabled ? .darkTint : .black5
        collectionView.backgroundColor = darkModeEnabled ? .darkTint : .black5
        collectionView.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = sectionTitle
        updateColors()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func isPostIdInBookmarks(post: PostObject, currListOfBookmarks: [PostObject]) -> PostObject? {
        guard let index = currListOfBookmarks.firstIndex(where: {$0.id == post.id}) else { return nil }
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
            getPosts(page: currentPage, sectionID: sectionID)
        }
    }
}

extension SectionCollectionViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects = feedData as [ListDiffable]
        if loading {
            objects.append(spinToken as ListDiffable)
        }
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else if let obj = object as? PostObject, obj.postType == .photoGallery {
            return PhotoGallerySectionController()
        } else if let obj = object as? PostObject, obj.postType == .video {
            return VideoSectionController()
        } else if let obj = object as? PostObject, obj.isEqual(toDiffableObject: feedData[0]) {
            let heroSC = HeroSectionController()
            heroSC.delegate = self
            return heroSC
        } else if let obj = object as? String, obj.contains("adToken") {
            return AdSectionController()
        }
        let articleSC = ArticleSectionController()
        articleSC.delegate = self
        return articleSC
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        let skeletonView = SkeletonFeedCell(frame: view.frame)
        skeletonView.isSkeletonable = true
        skeletonView.showAnimatedSkeleton()
        return skeletonView
    }
}

extension SectionCollectionViewController {

    func getPosts(page: Int, sectionID: Int) {

        fetchPosts(target: .section(section: sectionID, page: page)) { posts, error in
            if error == nil {
                self.loading = false
                var postsWithAds: [ListDiffable] = posts
                postsWithAds.insert("adToken\(self.adCount)" as ListDiffable, at: posts.count - 2)
                self.adCount += 1
                self.feedData.append(contentsOf: postsWithAds)
                self.refreshControl.endRefreshing()
                self.adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }

    @objc func refreshData() {
        currentPage = 1
        feedData = []
        getPosts(page: currentPage, sectionID: sectionID)
    }
}

extension SectionCollectionViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleStackViewController(post: article)
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
