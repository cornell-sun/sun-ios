//
//  FeedCollectionViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/3/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import Realm
import RealmSwift

class FeedCollectionViewController: ViewController, UIScrollViewDelegate {
    let FONTSIZE:CGFloat = 22.0
    var refreshControl = UIRefreshControl()
    var feedData: [PostObject] = []
    var firstPostObject: PostObject!
    var savedPosts: Results<PostObject>!
    var currentPage = 1
    var adIndex = 7
    var loading = false
    let spinToken = "spinner"
    var adCount = 1
    var adDict = [String: Int]()
    var currAdToken = ""
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
        navigationItem.title = "The Cornell Daily Sun"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: FONTSIZE)!
        ]
        if !feedData.isEmpty {
            let savedPostIds: [Int] = savedPosts.map({$0.id})
            feedData = feedData.map {
                RealmManager.instance.update(object: $0, to: savedPostIds.contains($0.id))
                return $0
            }
            self.adapter.reloadData(completion: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        //we could possibly have saved posts
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        //        if #available(iOS 11.0, *) {
        //            navigationController?.navigationBar.prefersLargeTitles = true
        //            self.navigationController?.navigationBar.largeTitleTextAttributes = [
        //                NSAttributedStringKey.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 38)!
        //            ]
        //        }

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = .offWhite
        adapter.collectionView?.refreshControl = refreshControl
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        savedPosts = RealmManager.instance.get()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func refreshData() {
        currentPage = 1
        feedData = []
        getPosts(page: currentPage)
    }

    func getPosts(page: Int) {
        fetchPosts(target: .posts(page: page)) { posts, error in
            if error == nil {
                    self.loading = false
                self.feedData.append(contentsOf: posts)
//                self.feedData.insert(adToken, at: adIndex*page)
                self.refreshControl.endRefreshing()
                self.adapter.performUpdates(animated: true, completion: nil)
            }
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
        objects = mergeAds(feed: objects)
        if loading {
            objects.append(spinToken as ListDiffable)
        } 

        return objects
    }
    
    func mergeAds(feed: [ListDiffable]) -> [ListDiffable] {
        var objects = feed
        currAdToken = "adToken\(adCount)"
        adDict[currAdToken] = adCount
        adCount += 1
        for (adtoken, adcount) in adDict {
            if(adcount <= currentPage) {
                objects.insert(adtoken as ListDiffable, at: adIndex*adcount)
            }
        }
        print(adCount)
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else if let obj = object as? PostObject, obj.isEqual(toDiffableObject: firstPostObject) {
            return HeroSectionController()
        } else if let obj = object as? PostObject, obj.postType == .photoGallery {
            return PhotoGallerySectionController()
        } else if let obj = object as? String, adDict[obj] != nil {
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

extension FeedCollectionViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleViewController(article: article)
        articleVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
