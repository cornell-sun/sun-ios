//
//  AuthorDetailViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/10/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import IGListKit
import UIKit

class AuthorDetailViewController: UIViewController {

    // MARK: View vars
    var adapter: ListAdapter!
    var collectionView: UICollectionView!

    // MARK: Data vars
    var author: AuthorObject
    var posts: [PostObject] = []

    init(author: AuthorObject) {
        self.author = author
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Writer Page"

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }

        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Networking

}

// MARK: - IGListKit
extension AuthorDetailViewController: ListAdapterDataSource {

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let authorDetail = AuthorDetailObject(bio: "Zachary Silver is a senior writer in The Sun's sports department. He was the sports editor on the 135th Editorial Board and a sports editor on the 134th before serving as a senior editor on the 136th. He is a senior in the College of Arts and Sciences and can be reached at zsilver@cornellsun.com, or follow him on Twitter @zachsilver.", email: nil, imageURL: nil, linkedIn: nil, name: "Nicholas Bogel-Burroughs", twitter: nil)

        return [authorDetail] + posts
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? AuthorDetailObject {
            return AuthorDetailSectionController(authorDetail: obj)
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

// MARK: - TabBarViewControllerDelegate
extension AuthorDetailViewController: TabBarViewControllerDelegate {

    func articleSectionDidPressOnArticle(_ article: PostObject) {

    }

}
