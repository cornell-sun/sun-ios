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
    var emoji: String
    
    init(nam: String, titl: String, home: String, liner: String, emoji: String) {
        name = nam
        title = titl
        origin = home
        oneLiner = liner
        self.emoji = emoji
    }
}

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var prevViewController: UIViewController!

    var tableView: UITableView!
    var members: [TeamMember] = []

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

        title = "App Team"
        
        //Calling hardcoded populator
        if members.count == 0 {
            members = [TeamMember(nam: "Austin Astorga '19", titl: "Developer", home: "Carlsbad, California", liner: "God's Plan", emoji: "🙏🏽"),
                       TeamMember(nam: "Mindy Lou '19", titl: "Developer", home: "Wayland, Massachusetts", liner: "A hot dog is not a sandwich", emoji: "🎉"),
                TeamMember(nam: "Chris Sciavolino '19", titl: "Developer", home: "Naples, Florida", liner: "What's the worst that can happen?", emoji: "👀"),
                TeamMember(nam: "Brendan Elliott '19", titl: "Designer", home: "Grand Rapids, Michigan", liner: "Ketchup should never be used before noon", emoji: "👨🏻‍💻"),
                TeamMember(nam: "Alexis Vinzons '19", titl: "Designer", home: "Mamaroneck, New York", liner: "The solution is in the framing of the problem", emoji: "💃"),
                TeamMember(nam: "Aditya Dwivedi '20", titl: "Developer", home: "Lucknow, India", liner: "Waffles > Pancakes", emoji: "🐪"),
                TeamMember(nam: "Theo Carrel '20", titl: "Developer", home: "New York, NY", liner: "It really do be like that sometimes", emoji: "🔥"),
                TeamMember(nam: "Mike Fang '21", titl: "Developer", home: "San Jose, California", liner: "Do not fear mistakes. There are none", emoji: "🐺"),
                TeamMember(nam: "Cameron Hamidi '21", titl: "Developer", home: "London, United Kingdom", liner: "Serenity now", emoji: "🍦"),
                TeamMember(nam: "Connie Liu '23", titl: "Designer", home: "Ambler, Pennsylvania", liner: "We don't do things because they are easy but because they are hard", emoji: "🤠"),
                TeamMember(nam: "SoYee Kim '22", titl: "Designer", home: "Seoul, South Korea", liner: "Smile while you still have teeth", emoji: "🌟"),
                TeamMember(nam: "Sophie Ruan '22", titl: "Designer", home: "Brooklyn, New York", liner: "Inhale courage, exhale fear", emoji: "🧋")
            ]
        }
        
        // Set up table view for settings
        tableView = UITableView()
        tableView.register(TeamTableViewCell.self, forCellReuseIdentifier: "TeamCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as? TeamTableViewCell {
            let member = members[indexPath.row]
            cell.setupCell(name: member.name, title: member.title, origin: member.origin, liner: member.oneLiner, emoji: member.emoji)
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
