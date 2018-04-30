//
//  SubscribeViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 3/23/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import SafariServices

class SubscribeViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    var pickerList: [String] = ["Cornell Student", "Cornell Alumnus", "Parent", "Cornell staff", "Other"]
    
    var headerLabel: UILabel!
    var descriptionTextView: UITextView!
    var actionButton: UIButton!
    var emailField: UITextField!
    var pickerView: UIPickerView!
    
    let headerHeight: CGFloat = 43
    let headerOffset: CGFloat = 22.5
    let descriptionHeight: CGFloat = 58
    let descriptionOffset: CGFloat = 17.5
    let descriptionOffsetBottom: CGFloat = 20
    let labelHeight: CGFloat = 17
    let labelOffsetTop: CGFloat = 19
    let labelOffsetBottom: CGFloat = 3
    let textHeight: CGFloat = 21.5
    let textWidth: CGFloat = 315
    let pickerHeight: CGFloat = 76.0
    let messageHeight: CGFloat = 95.0
    let screenWidth: CGFloat = 375
    let buttonWidth: CGFloat = 118.5
    let buttonHeight: CGFloat = 45.5
    let buttonOffset: CGFloat = 40.0
    
    override func viewWillAppear(_ animated: Bool) {
        titleCache = prevViewController.title
        prevViewController.title = "Settings"
        pickerView.selectRow(1, inComponent:0, animated:true)
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
        headerLabel.text = "Daily Newsletters"
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(ofSize: 36, weight: .bold)
        view.addSubview(headerLabel)
        var topArea = view.layoutMarginsGuide.snp.top
        var bottomArea = view.layoutMarginsGuide.snp.bottom
        if #available(iOS 11, *) {
            topArea = view.safeAreaLayoutGuide.snp.top
            bottomArea = view.safeAreaLayoutGuide.snp.bottom
        }

        headerLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(headerHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(topArea).offset(headerOffset)
        }
        
        descriptionTextView = UITextView()
        descriptionTextView.text = "Get Daily Sun headlines delivered to your inbox every day. \n You'll never miss a moment."
        descriptionTextView.textColor = .black
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(descriptionHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(headerLabel.snp.bottom).offset(descriptionOffset)
        }
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = .systemFont(ofSize: 14)
        nameLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(labelOffsetTop)
        }
        let nameField = UITextField()
        nameField.borderStyle = UITextBorderStyle.none
        //nameField.delegate = self
        nameField.font = UIFont(name:"HelveticaNeue", size: 18.0)
        view.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(textHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(nameLabel.snp.bottom).offset(labelOffsetBottom)
        }
        let nameBorder = CALayer()
        let width = CGFloat(1.0)
        nameBorder.borderColor = UIColor(red: 217/256, green: 217/256, blue: 217/256, alpha: 1).cgColor
        nameBorder.frame = CGRect(x: 0, y: textHeight - width, width:  textWidth*widthScale+2.0, height: textHeight+2)
        nameBorder.borderWidth = width
        nameField.layer.addSublayer(nameBorder)
        nameField.layer.masksToBounds = true
        
        let emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        emailLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(nameField.snp.bottom).offset(labelOffsetTop)
        }
        emailField = UITextField()
        emailField.borderStyle = UITextBorderStyle.none
        //emailField.delegate = self
        emailField.font = UIFont(name:"HelveticaNeue", size: 18.0)
        view.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(textHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(emailLabel.snp.bottom).offset(labelOffsetBottom)
        }
        let emailBorder = CALayer()
        emailBorder.borderColor = UIColor(red: 217/256, green: 217/256, blue: 217/256, alpha: 1).cgColor
        emailBorder.frame = CGRect(x: 0, y: textHeight - width, width:  textWidth*widthScale+2.0, height: textHeight+2)
        emailBorder.borderWidth = width
        emailField.layer.addSublayer(emailBorder)
        emailField.layer.masksToBounds = true
        
        let pickerLabel = UILabel()
        pickerLabel.text = "I am a"
        pickerLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        pickerLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        view.addSubview(pickerLabel)
        pickerLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(emailField.snp.bottom).offset(labelOffsetTop)
        }
        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        view.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(pickerHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(pickerLabel.snp.bottom).offset(labelOffsetBottom)
        }
        
        actionButton = UIButton()
        actionButton.backgroundColor = UIColor.white// (red: 238/255, green: 68/255, blue: 68/255, alpha: 1)
        actionButton.layer.cornerRadius = 20
        let bigRed = UIColor(red: 179/255, green: 27/255, blue: 27/255, alpha: 1)
        actionButton.layer.borderWidth = 2.5
        actionButton.layer.borderColor = bigRed.cgColor
        actionButton.setTitle("Subscribe", for: .normal)
        actionButton.setTitleColor(bigRed, for: .normal)
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(bottomArea).offset(-buttonOffset)
            make.centerX.equalTo(view.center.x)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let pickerLabel = view as? UILabel {
            pickerLabel.text = pickerList[row]
            return pickerLabel
        } else {
            let pickerLabel = UILabel()
            pickerLabel.font = UIFont(name: "Helvetica-Neue", size: 16)
            pickerLabel.textAlignment = .center
            pickerLabel.text = pickerList[row]
            return pickerLabel
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @objc func buttonAction() {
        if let url = URL(string: "https://cornellsun.us11.list-manage.com/subscribe/post") {
            if #available(iOS 11.0, *) {
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = true
                let vc = SFSafariViewController(url: url, configuration: config)
                present(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let safariVC = SFSafariViewController(url: url)
                self.present(safariVC, animated: true, completion: nil)
            }
        }
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
