//
//  SearchViewController.swift
//  Pods
//
//  Created by Chris Sciavolino on 9/17/17.
//
//

import UIKit
import IGListKit

class SearchViewController: UIViewController, UITableViewDelegate {

    var tableView: UITableView!
    let emptyLoadingView = UIView()
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    let searchController = UISearchController(searchResultsController: nil)
    let dimView = UIView()
    var currentQuery = ""
    let spinToken = "spinner"
    var currentPage = 1
    var endOfResults = false
    var loading = false
    var trendingTopics: [String] = []

    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.alwaysBounceVertical = true
        view.backgroundColor = .white
        return view
    }()

    lazy var adapter: ListAdapter  = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()

    var searchData: [PostObject] = [] {
        didSet {
            if searchData.isEmpty {
                spinner.startAnimating()
            } else {
                spinner.stopAnimating()
            }
        }
    }

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
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        self.definesPresentationContext = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        emptyLoadingView.addSubview(spinner)

        tableView = UITableView()
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        collectionView.isHidden = true
        view.addSubview(collectionView)

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        collectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        adapter.collectionView = collectionView
        adapter.collectionView?.backgroundColor = .offWhite
        adapter.dataSource = self
        adapter.scrollViewDelegate = self

        dimView.frame = tableView.frame
        dimView.backgroundColor = .black
        dimView.alpha = 0.0
        view.addSubview(dimView)

        // Set up the searchController delegate and the presentation view
        searchController.searchBar.delegate = self
        searchController.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false
    }

    override func viewDidAppear(_ animated: Bool) {
        //self.searchController.isActive = true
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
        }
        let searchSectionController = SearchSectionController()
        searchSectionController.delegate = self
        return searchSectionController
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        //eventually show uh-oh no searches found
        return emptyLoadingView
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        if !loading && distance < 300 && !collectionView.isHidden && !endOfResults {
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
        trendingLabel.font = .boldSystemFont(ofSize: 18)
        headerView.contentView.addSubview(trendingLabel)

        trendingLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.top.bottom.equalToSuperview().inset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set up custom search result cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.text = trendingTopics[indexPath.row]
        cell.textLabel?.textColor = .trendingBlue
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Only count the relevant results, likely capped around 10 - 15 or async infinite scroll
        return trendingTopics.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let topic = trendingTopics[indexPath.row]
        searchController.searchBar.text = topic
        searchBarSearchButtonClicked(searchController.searchBar)
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
        self.searchData = []
        self.tableView.isHidden = true
        self.adapter.performUpdates(animated: false)
        self.collectionView.isHidden = false
        fetchPosts(target: .search(query: query, page: currentPage)) { posts, error in
            if error == nil {
                self.searchData = posts
                self.adapter.performUpdates(animated: true)
                if posts.count < 10 {
                    self.endOfResults = true
                }
            }
        }
    }
}
extension SearchViewController: TabBarViewControllerDelegate {
    func articleSectionDidPressOnArticle(_ article: PostObject) {
        let articleVC = ArticleViewController(article: article)
        articleVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(articleVC, animated: true)
    }
}
