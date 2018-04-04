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

    var isFirstRun = true

    var loading = false

    var currentPage = 1
    let spinToken = "spinner"
    var adIndex = 7
    var adCount = 1
    var adDict = [String: Int]()
    var currAdToken = ""


    var feedData: [PostObject] = []
    var savedPostIds: [Int] = []
    var headlinePost: PostObject!

    var refreshControl = UIRefreshControl()

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
        super.viewWillAppear(animated)

        guard !isFirstRun else {
            isFirstRun = false
            return
        }

        setNavigationInformation()

        feedData = feedData.map {
            RealmManager.instance.update(object: $0, to: savedPostIds.contains($0.id))
            return $0
        }
        self.adapter.performUpdates(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        view.addSubview(collectionView)

        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = .black5
        adapter.collectionView?.refreshControl = refreshControl
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        savedPostIds = Array(RealmManager.instance.get()).map({$0.id})
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        if let mainPost = headlinePost {
            objects = [mainPost] + objects
        }

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

extension FeedCollectionViewController {

    func getPosts(page: Int) {

        fetchPosts(target: .posts(page: page)) { posts, error in
            if error == nil {
                self.loading = false
                self.feedData.append(contentsOf: posts)
                self.refreshControl.endRefreshing()
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
        navigationItem.title = "The Cornell Daily Sun"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: .mainHeaderSize)!
        ]
    }
}

extension FeedCollectionViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleViewController(article: article)
        articleVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
