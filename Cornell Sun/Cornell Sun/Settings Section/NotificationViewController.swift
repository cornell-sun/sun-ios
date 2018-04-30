//
//  NotificationViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 4/1/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

enum NotificationType: String {
    case breakingNews = "breaking-news"
    case opinion = "opinion"
    case sports = "sports"
    case artsAndEntertainment = "arts-and-entertainment"
    case science = "science"
    case dining = "dining"
    case multimedia = "multimedia"
    case localNews = "local-news"
    case sunspots = "sunspots"
}

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    
    var tableView: UITableView!
    var notifications: [(String, NotificationType)] = []

    override func viewWillAppear(_ animated: Bool) {
        titleCache = prevViewController.title
        prevViewController.title = "Settings"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        prevViewController.title = titleCache
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = .white
    
        //Calling hardcoded populator
        if notifications.count == 0 {
            notifications = [("Breaking News", .breakingNews), ("Local News", .localNews), ("Opinion", .opinion), ("Sports", .sports), ("Sunspots", .sunspots), ("Multimedia", .multimedia), ("Arts and Entertainment", .artsAndEntertainment), ("Science", .science), ("Dining", .dining)]
        }
        
        // Set up table view for settings
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationsTableViewCell {
            cell.notificationType = notifications[indexPath.row].1
            cell.setupCell(labelText: notifications[indexPath.row].0)
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
}
