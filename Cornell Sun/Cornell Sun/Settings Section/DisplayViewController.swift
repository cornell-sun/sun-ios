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
    
    override func viewWillAppear(_ animated: Bool) {
        titleCache = prevViewController.title
        prevViewController.title = "Settings"
        descriptionTextView.isScrollEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        prevViewController.title = titleCache
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = ""
        let widthScale = view.frame.width/screenWidth //Scaling width
        headerLabel = UILabel()
        headerLabel.text = getHeader()
        headerLabel.textColor = .black
        headerLabel.font = UIFont(name: "Sonnenstrahl-Ausgezeichnet", size: 36)
        headerLabel.textAlignment = .center
        view.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(headerHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(view.snp.top).offset(headerOffset)
        }
        
        descriptionTextView = UITextView()
        descriptionTextView.text = getText()
        descriptionTextView.textColor = .black
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
