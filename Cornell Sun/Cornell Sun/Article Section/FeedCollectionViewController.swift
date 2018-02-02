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
    var refreshControl = UIRefreshControl()
    var feedData: [PostObject] = []
    var firstPostObject: PostObject!
    var savedPosts: Results<PostObject>!
    var currentPage = 2
    var loading = false
    let spinToken = "spinner"
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

        navigationItem.title = "The Cornell Daily Sun"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 22)!
        ]
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [
                NSAttributedStringKey.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 34)!
            ]
        }

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
        let savedPostIds: [Int] = savedPosts.map({$0.id})
        API.request(target: .posts(page: page)) { (response) in
            self.loading = false
            guard let response = response else {return}
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: [])
                if let postArray = jsonResult as? [[String: Any]] {
                    for postDictionary in postArray {
                        if let post = PostObject(data: postDictionary) {
                            if self.firstPostObject == nil {
                                self.firstPostObject = post
                            }
                            if savedPostIds.contains(post.id) {
                                post.didSave = true
                            }
                            self.feedData.append(post)
                        }
                    }
                    self.refreshControl.endRefreshing()
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            } catch {
                print("could not parse")
                // can't parse data, show error
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
        if loading {
            objects.append(spinToken as ListDiffable)
        }
        return objects
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else if let obj = object as? PostObject, obj.isEqual(toDiffableObject: firstPostObject) {
            return HeroSectionController()
        } else if let obj = object as? PostObject, obj.postType == .photoGallery {
            return PhotoGallerySectionController()
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
