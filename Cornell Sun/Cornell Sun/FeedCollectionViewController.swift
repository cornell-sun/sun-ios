//
//  FeedCollectionViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/3/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

class FeedCollectionViewController: ViewController {
    var feedData: [PostObject] = []

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

        API.request(target: .posts(page: 1), success: { (response) in
            // parse your data
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
        }, error: { (_) in
            // error from Wordpress
        }, failure: { (_) in
            // show Moya error
        })

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FeedCollectionViewController: ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return feedData
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ArticleSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }

}
