//
//  TeamViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 5/26/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class TeamMember {
    var name: String
    var title: String
    var origin: String
    var oneLiner: String
    
    init(nam: String, titl: String, home: String, liner: String) {
        name = nam
        title = titl
        origin = home
        oneLiner = liner
    }
}

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    
    var tableView: UITableView!
    var members: [TeamMember] = []
    
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
        if members.count == 0 {
            members = [TeamMember(nam: "Austin Astorga '19", titl: "Developer", home: "Hometown, State", liner: "One Liner!"),
                TeamMember(nam: "Mindy Lou '19", titl: "Developer", home: "Hometown, State", liner: "One Liner!"),
                TeamMember(nam: "Chris Sciavolino '19", titl: "Developer", home: "Hometown, State", liner: "One Liner!"),
                TeamMember(nam: "Brendan Elliot '19", titl: "Designer", home: "Hometown, State", liner: "One Liner!"),
                TeamMember(nam: "Alexis Vinzons '19", titl: "Designer", home: "Hometown, State", liner: "One Liner!"),
                TeamMember(nam: "Aditya Dwivedi '20", titl: "Developer", home: "Hometown, State", liner: "One Liner!"),
                TeamMember(nam: "Theo Carrel '20", titl: "Developer", home: "Hometown, State", liner: "One Liner!"),
                TeamMember(nam: "Mike Fang '21", titl: "Developer", home: "Hometown, State", liner: "One Liner!")]
        }
        
        // Set up table view for settings
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: "TeamCell")
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamTableViewCell {
            let member = members[indexPath.row]
            cell.setupCell(name: member.name, title: member.title, origin: member.origin, liner: member.oneLiner)
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
}

