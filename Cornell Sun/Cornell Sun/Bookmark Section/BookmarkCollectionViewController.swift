//
//  BookmarkCollectionViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/13/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import Realm
import RealmSwift

class BookmarkCollectionViewController: ViewController, UIScrollViewDelegate {
    var token: NotificationToken?
    var realmData: Results<PostObject> {
        return RealmManager.instance.get()
    }

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        return view
    }()

    lazy var adapter: ListAdapter  = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = UIColor(white: 241.0 / 255.0, alpha: 1.0)
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        token = realmData.observe { [weak self] changes in
            switch changes {
            case .update:
                self?.adapter.performUpdates(animated: true, completion: nil)
            default:
                break
            }
        }
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
        let bookmarkedPosts = realmData.map {$0}
        return bookmarkedPosts.sorted { (post1, post2) -> Bool in
            guard let post1Date = post1.bookmarkDate, let post2Date = post2.bookmarkDate else {return false}
            return post1Date.compare(post2Date) == .orderedDescending
        }
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {

        if let obj = object as? PostObject, obj.postType == .photoGallery {
            return PhotoGallerySectionController()
        }

        let bookmarkSC = BookmarkSectionController()
        bookmarkSC.delegate = self
        return bookmarkSC
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension BookmarkCollectionViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleViewController(article: article)
        articleVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
