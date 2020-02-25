//
//  NotificationViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 4/1/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import OneSignal

enum NotificationType: String {
    case breakingNews = "breaking-news"
    case opinion = "opinion"
    case sports = "sports"
    case artsAndEntertainment = "arts-and-entertainment"
    case science = "science"
    case dining = "dining"
    case multimedia = "multimedia"
    case localNews = "local-news"
    //case sunspots = "sunspots"
}

protocol NotificationsTableViewCellDelegate: class {
    func switchToggled(for cell: NotificationsTableViewCell, isSubscribed: Bool)
}

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var prevViewController: UIViewController!
    
    var tableView: UITableView!
    var notifications: [(String, NotificationType)] = []
    var notificationsDisplay: [(String, UIImage)] = []

    let userDefaults = UserDefaults.standard

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        updateColors()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notifications"
    
        //Calling hardcoded populator
        if notifications.count == 0 {
            notifications = [("Breaking News", .breakingNews), ("Local News", .localNews), ("Opinion", .opinion), ("Sports", .sports), ("Multimedia", .multimedia), ("Arts and Entertainment", .artsAndEntertainment), ("Science", .science), ("Dining", .dining)]
            
            let iconExt = darkModeEnabled ? "Dark" : "Light"
            
            //swiftlint:disable:next force_cast
            notificationsDisplay = [("News you need to know as it happens", UIImage(named: "breakingNews" + iconExt)), ("Cornell and the surrounding Ithaca community", UIImage(named: "localNews" + iconExt)), ("Thoughts from your peers, professors, and alumni", UIImage(named: "opinion" + iconExt)), ("Scores, recaps, features and more about the Red", UIImage(named: "sports" + iconExt)), ("Photos, videos, and interviews about the Cornell community", UIImage(named: "multimedia" + iconExt)), ("Music, movies, fashion, and performance", UIImage(named: "arts" + iconExt)), ("What you need to know about research, Cornell Tech", UIImage(named: "science" + iconExt)), ("All the food news on campus and in the Ithaca area", UIImage(named: "dining" + iconExt))] as! [(String, UIImage)]
        }
        
        // Set up table view for settings
        tableView = UITableView(frame: .zero)
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func updateColors() {
        view.backgroundColor = darkModeEnabled ? .darkCell : .white
        tableView.backgroundColor = darkModeEnabled ? .darkCell : .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationsTableViewCell {
            cell.delegate = self
            let isSubscribed = userDefaults.bool(forKey: notifications[indexPath.row].1.rawValue)
            cell.setupCell(labelText: notifications[indexPath.row].0, descriptionText: notificationsDisplay[indexPath.row].0, icon: notificationsDisplay[indexPath.row].1, isSubscribed: isSubscribed)
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
}

// MARK: - NotificationTableViewCellDelegate
extension NotificationViewController: NotificationsTableViewCellDelegate {
    func switchToggled(for cell: NotificationsTableViewCell, isSubscribed: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let notificationType = notifications[indexPath.row].1
        userDefaults.set(isSubscribed, forKey: notificationType.rawValue)
        if isSubscribed {
            OneSignal.sendTag(notificationType.rawValue, value: notificationType.rawValue)
        } else {
            OneSignal.deleteTag(notificationType.rawValue)
        }
    }
}
