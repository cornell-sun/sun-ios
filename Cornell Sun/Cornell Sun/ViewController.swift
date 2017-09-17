//
//  ViewController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/20/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import LGSideMenuController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .white

        navigationItem.leftBarButtonItem =  UIBarButtonItem(title: "Menu",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showLeftViewAnimated(_:)))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showSearchViewController))

    }

    func showSearchViewController() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
