//
//  ViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/20/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white
        navigationItem.title = "The Cornell Daily Sun"
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 22)!
        ]

        /* navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showSearchViewController))
         */
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "The Cornell Daily Sun"
    }

    @objc func showSearchViewController() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
