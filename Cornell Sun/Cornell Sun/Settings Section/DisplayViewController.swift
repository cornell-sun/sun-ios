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
        descriptionTextView.isScrollEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        prevViewController.title = titleCache
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = .white
        let navBar = navigationController?.navigationBar
        navBar?.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        navBar?.shadowImage = UIColor.lightGray.as1ptImage()
        self.title = ""
        let widthScale = view.frame.width/screenWidth //Scaling width
        headerLabel = UILabel()
        headerLabel.text = getHeader()
        headerLabel.textColor = .black
        headerLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 36.0)
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
        descriptionTextView.font = UIFont(name: "HelveticaNeue", size: 16.0)
        descriptionTextView.isEditable = false
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(descriptionHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(headerLabel.snp.bottom).offset(descriptionOffset)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getText() -> String {
        switch type {
        case .appteam:
            return "Austin Astorga '19 \nChris Sciavolino '19 \nMindy Lou '19 \nAditya Dwivedi '20 \nTheo Carrel '20 \nMike Fang '21 \nBrendan Elliot '19 \nAlexis Vinzons '19"
        case .history:
            return "The Cornell Sun was founded in 1880 by William Ballard Hoyt to challenge Cornell's original and leading publication, the weekly Cornell Era (founded 1868).\n The Sun boasted in its opening paragraph: \"We have no indulgence to ask, no favors to beg. \" The paper incorporated and changed to daily frequency, earning its longstanding boast \"Ithaca's Only Morning Newspaper.\" In 1912 it added a second, \"first collegiate member of the Associated Press.\""
        default:
            return ""
        }
    }
    
    func getHeader() -> String {
        switch type {
        case .appteam:
            return "App Team"
        case .history:
            return "History"
        default:
            return ""
        }
    }
}
