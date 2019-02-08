//
//  SearchViewController.swift
//  Pods
//
//  Created by Chris Sciavolino on 9/17/17.
//
//

import UIKit
import IGListKit
import Crashlytics

class SearchViewController: UIViewController, UITableViewDelegate {

    var tableView: UITableView!
    let emptySearchView = EmptyView(image: #imageLiteral(resourceName: "empty-search-sun"), title: "No Results", description: "Check your spelling?")
    let searchController = UISearchController(searchResultsController: nil)
    let dimView = UIView()
    var currentQuery = ""
    let spinToken = "spinner"
    var empty = false
    var currentPage = 1
    var endOfResults = false
    var loading = false
    var trendingTopics: [String] = []
    let TRENDINGLABEL_LEADING: CGFloat = 18.0
    let TRENDINGLABEL_TOP_BOTTOM_TRAILING: CGFloat = 8
    let DISTANCE: CGFloat = 300.0

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        return view
    }()

    lazy var adapter: ListAdapter  = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    var searchData: [PostObject] = []

    init(fetchTrending: Bool) {
        super.init(nibName: nil, bundle: nil)
        if fetchTrending {
            getTrending { trending, error in
                if error == nil {
                    self.trendingTopics = trending
                }
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        title = "Search"
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        definesPresentationContext = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black5

        tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
        view.addSubview(tableView)

        collectionView.isHidden = true
        collectionView.backgroundColor = .collectionBackground
        view.addSubview(collectionView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = .black5
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        dimView.backgroundColor = .black
        dimView.alpha = 0.0
        view.addSubview(dimView)

        dimView.snp.makeConstraints { make in
            make.edges.equalTo(tableView)
        }

        // Set up the searchController delegate and the presentation view
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search For Articles"
        searchController.searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 0), for: .search)
        if let textField = searchController.searchBar.subviews.first?.subviews.compactMap({$0 as? UITextField }).first {
            textField.subviews.first?.isHidden = true
            textField.layer.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.05).cgColor
            textField.layer.cornerRadius = 15.5
            textField.layer.masksToBounds = true
            textField.font = UIFont(name: "SanFranciscoDisplay-Medium", size: 14)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController: UIScrollViewDelegate, ListAdapterDataSource {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects = searchData as [ListDiffable]
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
        } else if let obj = object as? PostObject, obj.postType == .video {
            return VideoSectionController()
        }
        let searchSectionController = BookmarkSearchSectionController()
        searchSectionController.delegate = self
        return searchSectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        if empty {
            return emptySearchView
        } else {
            let skeletonView = SkeletonFeedCell(frame: view.frame)
            skeletonView.isSkeletonable = true
            skeletonView.showAnimatedSkeleton()
            return skeletonView
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < DISTANCE && !collectionView.isHidden && !endOfResults {
            loading = true
            adapter.performUpdates(animated: true, completion: nil)
            currentPage += 1
            fetchPosts(target: .search(query: currentQuery, page: currentPage)) { posts, error in
                if error == .noResultsError {
                    self.endOfResults = true
                    self.loading = false
                } else {
                    self.loading = false
                    self.searchData.append(contentsOf: posts)
                    self.adapter.performUpdates(animated: true)
                    self.collectionView.isHidden = false
                }
            }

        }
    }
}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UITableViewHeaderFooterView()
        headerView.contentView.backgroundColor = .white
        let trendingLabel = UILabel()
        trendingLabel.text = "Trending Topics"
        trendingLabel.font = .headerTitle
        headerView.contentView.addSubview(trendingLabel)

        trendingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(TRENDINGLABEL_LEADING)
            make.top.bottom.equalToSuperview().inset(TRENDINGLABEL_TOP_BOTTOM_TRAILING)
            make.trailing.lessThanOrEqualToSuperview().inset(TRENDINGLABEL_TOP_BOTTOM_TRAILING)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set up custom search result cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.text = trendingTopics[indexPath.row]
        cell.textLabel?.font = .secondaryHeader
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingTopics.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let topic = trendingTopics[indexPath.row]
        searchController.searchBar.text = topic
        searchBarSearchButtonClicked(searchController.searchBar)
        Answers.logCustomEvent(withName: "Trending Selected", customAttributes: ["Topic": topic])
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(searchBar.text == "", animated: false)
        if searchBar.text == "" {
            collectionView.isHidden = true
            tableView.isHidden = false
        }
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(searchBar.text == "", animated: false)
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0.5
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dimView.alpha = 0.0
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        empty = false
        searchBar.endEditing(true)
        collectionView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
        guard let query = searchBar.text else { return }
        if query == "" {
            return
        }
        currentQuery = query
        currentPage = 1
        endOfResults = false
        searchBar.setShowsCancelButton(false, animated: true)
        dimView.alpha = 0.0
        searchData = []
        tableView.isHidden = true
        adapter.performUpdates(animated: false)
        collectionView.isHidden = false
        fetchPosts(target: .search(query: query, page: currentPage)) { posts, error in
            if error == nil {
                self.searchData = posts
                self.adapter.performUpdates(animated: true)
                if posts.count == 0 {
                    self.empty = true
                }
                if posts.count < 10 {
                    self.endOfResults = true
                }
            }
        }
        
        //Set up search analytics
        Answers.logSearch(withQuery: "Search", customAttributes: ["Searched For": query])
    }
}
extension SearchViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleStackViewController(post: article)
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
