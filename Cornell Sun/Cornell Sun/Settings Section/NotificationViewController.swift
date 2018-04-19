//
//  NotificationViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 4/1/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    
    var tableView: UITableView!
    var notifications: [String] = []

    override func viewWillAppear(_ animated: Bool) {
        titleCache = prevViewController.title
        prevViewController.title = "Settings"
        descriptionTextView.isScrollEnabled = false
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
            notifications = ["Breaking News", "Local News", "Opinion", "Sports", "Sunspots", "Multimedia", "Arts and Entertainment", "Science", "Dining"]
        }
        
        // Set up table view for settings
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "NotificationCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as? NotificationsTableViewCell {
            cell.setupCell(labelText: notifications[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
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
