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
    var feedData: [PostObject] = []
    var currentPage = 1
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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        adapter.scrollViewDelegate = self
        getPosts(page: currentPage)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getPosts(page: Int) {
        API.request(target: .posts(page: page), success: { (response) in
            // parse your data
            self.loading = false
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: [])
                if let postArray = jsonResult as? [[String: Any]] {
                    for postDictionary in postArray {
                        guard
                            let links = postDictionary["_links"] as? [String: Any],
                            let media = links["wp:featuredmedia"] as? [[String: Any]],
                            var mediaUrl = media[0]["href"] as? String
                            else {
                                return
                        }
                        mediaUrl = (mediaUrl as NSString).lastPathComponent
                        API.request(target: .media(mediaId: mediaUrl), success: { (response2) in
                            do {
                                let mediaJsonResult = try JSONSerialization.jsonObject(with: response2.data, options: [])
                                if let mediaObject = mediaJsonResult as? [String: Any],
                                    let mediaDetails = mediaObject["media_details"] as? [String: Any],
                                    let sizes = mediaDetails["sizes"] as? [String: Any],
                                    let rectThumbnail = sizes["rect_thumb"] as? [String: Any],
                                    let sourceUrl = rectThumbnail["source_url"] as? String {
                                    if let post = PostObject(data: postDictionary as [String: AnyObject], mediaLink: sourceUrl) {
                                        self.feedData.append(post)
                                    }
                                }
                                self.adapter.performUpdates(animated: true, completion: nil)
                            } catch {

                            }
                        }, error: { (error) in
                            print("error", error)
                        }, failure: { (error) in
                            print("moya error", error)
                        })
                    }

                }

            } catch {
                print("could not parse")
                // can't parse data, show error
            }
        }, error: { (error) in
            print("error in wp", error.localizedDescription)
            // error from Wordpress
        }, failure: { (_) in
            print("moya error")
            // show Moya error
        })
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 200 {
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
        }
        return ArticleSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}
