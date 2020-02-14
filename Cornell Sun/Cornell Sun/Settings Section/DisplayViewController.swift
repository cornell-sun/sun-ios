//
//  DisplayViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 3/25/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class DisplayViewController: UIViewController {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    var type: SettingType!
    
    var headerLabel: UILabel!
    var descriptionTextView: UITextView!
    
    let headerHeight: CGFloat = 43
    let headerOffset: CGFloat = 86.5
    let descriptionHeight: CGFloat = 258
    let descriptionOffset: CGFloat = 17.5
    let descriptionOffsetBottom: CGFloat = 20
    let screenWidth: CGFloat = 375
    let textWidth: CGFloat = 315
    
    var tabHidden: [String : Bool] = ["hidden" : true]
    
    var darkModeEnabled: Bool!
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleCache = prevViewController.title
        prevViewController.title = "Settings"
        tabBarController?.tabBar.isHidden = true
        descriptionTextView.isScrollEnabled = true
        
        tabHidden["hidden"] = true
        
        NotificationCenter.default.post(name: Notification.Name("hideTabBar"), object: nil, userInfo: tabHidden)
    
        updateColors()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prevViewController.title = titleCache
        tabBarController?.tabBar.isHidden = false
        tabHidden["hidden"] = false
        NotificationCenter.default.post(name: Notification.Name("hideTabBar"), object: nil, userInfo: tabHidden)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")

        self.title = ""
        let widthScale = view.frame.width/screenWidth //Scaling width
        headerLabel = UILabel()
        headerLabel.text = getHeader()
        headerLabel.font = UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 36)
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(headerHeight)
            make.centerX.equalTo(view.center.x)
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaInsets.top).offset(headerOffset)
            } else {
                make.top.equalToSuperview().offset(headerOffset)
            }
        }
        
        descriptionTextView = UITextView()
        descriptionTextView.text = getText()
        descriptionTextView.font = UIFont(name: "Georgia", size: 20)
        descriptionTextView.isEditable = false
        descriptionTextView.textContainer.lineFragmentPadding = 0
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalToSuperview()
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(headerLabel.snp.bottom).offset(descriptionOffset)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateColors), name: .darkModeToggle, object: nil)
        
        updateColors()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func updateColors() {
        
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        
        view.backgroundColor = darkModeEnabled ? .darkCell : .white
        headerLabel.textColor = darkModeEnabled ? .darkText : .black
        descriptionTextView.textColor = darkModeEnabled ? .darkText : .black
        descriptionTextView.backgroundColor = darkModeEnabled ? .darkCell : .white
        
    }
    
    func getText() -> String {
        switch type! {
        case .appteam:
            return "Austin Astorga '19 \nChris Sciavolino '19 \nMindy Lou '19 \nAditya Dwivedi '20 \nTheo Carrel '20 \nMike Fang '21 \nBrendan Elliott '19 \nAlexis Vinzons '19"
        case .history:
            return "The Cornell Daily Sun is an independent, daily student-run newspaper serving the Cornell University and Ithaca, NY, communities.\n\nFounded in 1880, The Sun is the oldest continuously independent college daily in the United States.\n\nThe Sun publishes a print edition on Monday, Tuesday and Thursday during the academic year and is free on newsstands and online. The Sun is staffed entirely by Cornell students, aside from a few full-time production and business positions, and operates out of an office building in downtown Ithaca."
        default:
            return ""
        }
    }
    
    func getHeader() -> String {
        switch type! {
        case .appteam:
            return "App Team"
        case .history:
            return "The Cornell Daily Sun"
        default:
            return ""
        }
    }
}
