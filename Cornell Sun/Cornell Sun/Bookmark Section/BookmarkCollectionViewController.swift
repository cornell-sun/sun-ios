//
//  BookmarkCollectionViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/13/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

class BookmarkCollectionViewController: ViewController, UIScrollViewDelegate {
    fileprivate var observer: NSKeyValueObservation?
    var isFirstRun = true
    var bookmarkPosts: [PostObject] = []

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        return view
    }()

    lazy var adapter: ListAdapter  = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewWillAppear(_ animated: Bool) {
        title = "Bookmarks"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.headerTitle
        ]

        guard !isFirstRun else {
            isFirstRun = false
            return
        }
        self.adapter.performUpdates(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bookmarks"

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = .black5
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        observer = PostOffice.instance.observe(\.packages, options: [.initial, .new]) { (_, change) in
            if let newValue = change.newValue {
                self.bookmarkPosts = newValue
                self.adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }

    deinit {
        observer?.invalidate()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BookmarkCollectionViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let bookmarkedPosts = bookmarkPosts
        return bookmarkedPosts.sorted { (post1, post2) -> Bool in
            guard let post1Date = post1.storeDate, let post2Date = post2.storeDate else {return false}
            return post1Date.compare(post2Date) == .orderedDescending
        }
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {

        if let obj = object as? PostObject, obj.postType == .photoGallery {
            return PhotoGallerySectionController()
        }

        let bookmarkSC = BookmarkSearchSectionController(forBookmarks: true)
        bookmarkSC.delegate = self
        return bookmarkSC
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension BookmarkCollectionViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleStackViewController(post: article)
        articleVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
