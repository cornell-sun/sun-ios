//
//  SectionViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 2/12/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

enum Sections {
    case opinion(id: Int)
    case sports(id: Int)
    case arts(id: Int)
    case science(id: Int)
    case dining(id: Int)
    case multimedia(id: Int)
    //case sunspots
}

class SectionViewController: UIViewController {
    var tableView: UITableView!
    var sections: [Sections] = [.opinion(id: 3), .sports(id: 4), .arts(id: 5), .science(id: 6), .dining(id: 7), .multimedia(id: 9)]

    override func viewWillAppear(_ animated: Bool) {
        title = "Sections"
        navigationController?.navigationBar.barTintColor = .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sectionCell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func sectionToString(section: Sections) -> String {
        switch section {
        case .opinion:
            return "Opinion"
        case .sports:
            return "Sports"
        case .arts:
            return "Arts & Entertainment"
        case .science:
            return "Science"
        case .dining:
            return "Dining"
        case .multimedia:
            return "Multimedia"
        //case .sunspots:
            //return "Sunspots"
        }
    }
}

extension SectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCell") else {
            return UITableViewCell()
        }
        cell.textLabel?.text = sectionToString(section: sections[indexPath.row])
        cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = sections[indexPath.row]
        let sectionVC = SectionCollectionViewController(with: section, sectionTitle: sectionToString(section: section))
        navigationController?.pushViewController(sectionVC, animated: true)
    }
}
