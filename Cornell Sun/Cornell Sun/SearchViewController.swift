//
//  SearchViewController.swift
//  Pods
//
//  Created by Chris Sciavolino on 9/17/17.
//
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate {

    var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    let dimView = UIView()
    var searchResults: [String] = ["Current Text", "Search Result 1", "Search Result 2", "Search Result 3", "..."]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .white

        // Set up table view for search results
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        dimView.frame = tableView.frame
        dimView.backgroundColor = .black
        dimView.alpha = 0.0
        view.addSubview(dimView)
        // Set up the searchController delegate and the presentation view
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false

        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = searchController.searchBar
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        //self.searchController.isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Set up custom search result cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath)
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Only count the relevant results, likely capped around 10 - 15 or async infinite scroll
        return searchResults.count
    }
}

extension SearchViewController: UISearchControllerDelegate {

    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }

}

extension SearchViewController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0.5
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dimView.alpha = 0.0
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("search button pressed", searchBar.text ?? "")
        dimView.alpha = 0.0
    }
}
