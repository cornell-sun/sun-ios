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
    let searchController = UISearchController()
    var searchResults: [String] = ["Current Text", "Search Result 1", "Search Result 2", "Search Result 3", "..."]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        // Set up table view for search results
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchResultCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        // Set up the searchController delegate and the presentation view
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true

        // Could also make the middle element of the navbar equal to this
        tableView.tableHeaderView = searchController.searchBar
    }

    override func viewDidAppear(_ animated: Bool) {
        self.searchController.isActive = true
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

extension SearchViewController: UISearchResultsUpdating {
    
    // Called whenever the searchbar becomes first responder and when text is changed
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""

        // update this - only updates the first cell as of right now
        if searchResults.isEmpty {
            searchResults = [searchText]
        } else {
            searchResults[0] = searchText
        }

        tableView.reloadData()
    }
}
