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
    var refreshControl = UIRefreshControl()
    var feedData: [PostObject] = []
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

    init(with section: Sections, sectionTitle: String) {
        super.init(nibName: nil, bundle: nil)
        sectionSelected = section
        title = sectionTitle
        var sectionID = 0
        switch section {
        case .opinion(let id), .arts(let id), .dining(let id), .multimedia(let id), .science(let id), .sports(let id):
            sectionID = id
        }

        fetchPosts(target: .section(section: sectionID, page: 1)) { posts, error in
            if error == nil {
            self.feedData = posts
            self.adapter.reloadData(completion: nil)
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

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = .offWhite
        adapter.collectionView?.refreshControl = refreshControl
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        }
        let articleSC = ArticleSectionController()
        articleSC.delegate = self
        return articleSC
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

extension SectionCollectionViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleViewController(article: article)
        articleVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
