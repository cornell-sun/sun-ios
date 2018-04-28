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

    var sectionSelected: Sections!
    var emptySpinnerView = UIView()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var refreshControl = UIRefreshControl()
    var feedData: [PostObject] = [] {
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
    var adIndex = 7
    var adCount = 1
    var adDict = [String: Int]()
    var currAdToken = ""
    var sectionID = 0
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

    init(with section: Sections, sectionTitle: String) {
        super.init(nibName: nil, bundle: nil)
        sectionSelected = section
        title = sectionTitle
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.headerTitle
        ]
        
        switch section {
        case .opinion(let id), .arts(let id), .dining(let id), .multimedia(let id), .science(let id), .sports(let id):
            sectionID = id
        }

        fetchPosts(target: .section(section: sectionID, page: 1)) { posts, error in
            if error == nil {
            self.feedData = posts
            self.adapter.reloadData(completion: nil)
            } else {
                print(error)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black

        emptySpinnerView.addSubview(spinner)

        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = .white
        adapter.collectionView?.refreshControl = refreshControl
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
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
            getPosts(page: currentPage, sectionID: sectionID)
        }
    }
}

extension SectionCollectionViewController: ListAdapterDataSource {
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
            if adcount <= currentPage && objects.count >= adIndex * adcount {
                objects.insert(adtoken as ListDiffable, at: adIndex*adcount)
            }
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
        } else if let obj = object as? String, adDict[obj] != nil {
            return AdSectionController()
        }
        let articleSC = ArticleSectionController()
        articleSC.delegate = self
        return articleSC
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        if feedData.isEmpty {
            spinner.startAnimating()
        }
        return emptySpinnerView
    }
}

extension SectionCollectionViewController {
    
    func getPosts(page: Int, sectionID: Int) {
        
        fetchPosts(target: .section(section: sectionID, page: page)) { posts, error in
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
        getPosts(page: currentPage, sectionID: sectionID)
    }
}

extension SectionCollectionViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleStackViewController(post: article)
        articleVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
