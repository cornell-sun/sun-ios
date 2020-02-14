//
//  ContactViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 3/23/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    var settingType: SettingType!
    
    var headerLabel: UILabel!
    var descriptionTextView: UILabel!
    var actionButton: UIButton!
    var subjectLabel: UILabel!
    var subjectField: UITextField!
    var subjectBorder: CALayer!
    var emailField: UITextField!
    var messageField: UITextView!
    var nameLabel: UILabel!
    var nameField: UITextField!
    var nameBorder: CALayer!
    var emailLabel: UILabel!
    var emailBorder: CALayer!
    var messageLabel: UILabel!
    
    let contactEmail = "news@cornellsun.com"
    let feedbackEmail = "feedback@cornellsun.com"
    
    let headerHeight: CGFloat = 43
    let headerOffset: CGFloat = 22.5
    let descriptionHeight: CGFloat = 65
    let descriptionOffset: CGFloat = 17.5
    let descriptionOffsetBottom: CGFloat = 20
    let labelHeight: CGFloat = 17
    let labelOffsetTop: CGFloat = 19
    let labelOffsetBottom: CGFloat = 3
    let textHeight: CGFloat = 21.5
    let textWidth: CGFloat = 315
    let messageHeight: CGFloat = 95.0
    let screenWidth: CGFloat = 375
    let buttonWidth: CGFloat = 118.5
    let buttonHeight: CGFloat = 45.5
    let buttonOffset: CGFloat = 40
    
    var darkModeEnabled: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleCache = prevViewController.title
        prevViewController.title = "Settings"
        tabBarController?.tabBar.isHidden = true
        updateColors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        prevViewController.title = titleCache
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        self.title = ""
        let widthScale = view.frame.width/screenWidth //Scaling width
        headerLabel = UILabel()
        headerLabel.text = getHeader()
        headerLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 36.0)
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
        
        descriptionTextView = UILabel()
        descriptionTextView.text = getText()
        descriptionTextView.numberOfLines = 0
        descriptionTextView.font = UIFont(name: "HelveticaNeue", size: 16.0)
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(getText().height(withConstrainedWidth: textWidth*widthScale, font: descriptionTextView.font))
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(headerLabel.snp.bottom).offset(descriptionOffset)
        }
        
        subjectLabel = UILabel()
        subjectLabel.text = "Subject"
        subjectLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
        view.addSubview(subjectLabel)
        subjectLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(labelOffsetTop)
        }
        
        subjectField = UITextField()
        subjectField.borderStyle = UITextField.BorderStyle.none
        subjectField.delegate = self
        subjectField.font = UIFont(name: "HelveticaNeue", size: 18.0)
        view.addSubview(subjectField)
        subjectField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(textHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(subjectLabel.snp.bottom).offset(labelOffsetBottom)
        }
        
        subjectBorder = CALayer()
        let width = CGFloat(1.0)
        subjectBorder.frame = CGRect(x: 0, y: textHeight - width, width: textWidth*widthScale+2.0, height: textHeight+2)
        subjectBorder.borderWidth = width
        subjectField.layer.addSublayer(subjectBorder)
        subjectField.layer.masksToBounds = true
        
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(subjectField.snp.bottom).offset(labelOffsetTop)
        }
        
        nameField = UITextField()
        nameField.borderStyle = UITextField.BorderStyle.none
        nameField.delegate = self
        nameField.font = UIFont(name: "HelveticaNeue", size: 18.0)
        view.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(textHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(nameLabel.snp.bottom).offset(labelOffsetBottom)
        }
        
        nameBorder = CALayer()
        nameBorder.frame = CGRect(x: 0, y: textHeight - width, width: textWidth*widthScale+2.0, height: textHeight+2)
        nameBorder.borderWidth = width
        nameField.layer.addSublayer(nameBorder)
        nameField.layer.masksToBounds = true
        
        emailLabel = UILabel()
        emailLabel.text = "Email"
        emailLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
        view.addSubview(emailLabel)
        emailLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(nameField.snp.bottom).offset(labelOffsetTop)
        }
        
        emailField = UITextField()
        emailField.borderStyle = UITextField.BorderStyle.none
        emailField.textColor = darkModeEnabled ? .white90 : .black
        emailField.delegate = self
        emailField.font = UIFont(name: "HelveticaNeue", size: 18.0)
        view.addSubview(emailField)
        emailField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(textHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(emailLabel.snp.bottom).offset(labelOffsetBottom)
        }
        
        emailBorder = CALayer()
        emailBorder.frame = CGRect(x: 0, y: textHeight - width, width: textWidth*widthScale+2.0, height: textHeight+2)
        emailBorder.borderWidth = width
        emailField.layer.addSublayer(emailBorder)
        emailField.layer.masksToBounds = true
        
        messageLabel = UILabel()
        messageLabel.text = "Message"
        messageLabel.font = UIFont(name: "HelveticaNeue", size: 14.0)
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(emailField.snp.bottom).offset(labelOffsetTop)
        }
        
        messageField = UITextView()
        messageField.addDoneButton()
        messageField.delegate = self
        messageField.font = UIFont(name: "HelveticaNeue", size: 18.0)
        view.addSubview(messageField)
        
        actionButton = UIButton()
        actionButton.layer.cornerRadius = 20
        actionButton.layer.borderWidth = 2.5
        actionButton.setTitle("Send", for: .normal)
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(bottomArea).offset(-buttonOffset)
            make.centerX.equalTo(view.center.x)
        }

        messageField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(messageLabel.snp.bottom).offset(labelOffsetBottom)
            make.bottom.equalTo(actionButton.snp.top).offset(-8)
        }
        
        updateColors()
    }
    
    @objc func updateColors() {
        
        darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
        
        view.backgroundColor = darkModeEnabled ? .darkCell : .white
        headerLabel.textColor = darkModeEnabled ? .white90 : .black
        descriptionTextView.textColor = darkModeEnabled ? .white90 : .black
        subjectLabel.textColor = darkModeEnabled ? .white60 : UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        subjectField.textColor = darkModeEnabled ? .white90 : .black
        subjectBorder.borderColor = darkModeEnabled ? UIColor.white60.cgColor : UIColor(red: 217/256, green: 217/256, blue: 217/256, alpha: 1).cgColor
        nameLabel.textColor = darkModeEnabled ? .white60 : UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        nameField.textColor = darkModeEnabled ? .white90 : .black
        nameBorder.borderColor = darkModeEnabled ? UIColor.white60.cgColor : UIColor(red: 217/256, green: 217/256, blue: 217/256, alpha: 1).cgColor
        emailLabel.textColor = darkModeEnabled ? .white60 : UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        emailBorder.borderColor = darkModeEnabled ? UIColor.white60.cgColor : UIColor(red: 217/256, green: 217/256, blue: 217/256, alpha: 1).cgColor
        messageLabel.textColor = darkModeEnabled ? .white60 : UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        messageField.backgroundColor = darkModeEnabled ? .darkCell : .white
        messageField.textColor = darkModeEnabled ? .white90 : .black
        actionButton.backgroundColor = darkModeEnabled ? .darkCell : .white
        let titleColor = darkModeEnabled ? UIColor.white90 : UIColor.brick
        actionButton.layer.borderColor = titleColor.cgColor
        actionButton.setTitleColor(titleColor, for: .normal)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getText() -> String {
        guard let type = settingType else { return "" }
        switch type {
        case .contactus:
            return "Send us a message for advertising inquiries, news tips, corrections, or anything else."
        case .feedback:
            return "We’d love to get feedback to improve our app. Let us know your thoughts!"
        default:
            return ""
        }
    }
    
    func getHeader() -> String {
        guard let type = settingType else { return "" }
        switch type {
        case .contactus:
            return "Contact us"
        case .feedback:
            return "Hello!"
        default:
            return ""
        }
    }
    
    @objc func buttonAction() {
        if MFMailComposeViewController.canSendMail() {
            let mailer = MFMailComposeViewController()
            mailer.mailComposeDelegate = self
            switch settingType! {
            case .contactus:
                    mailer.setToRecipients([contactEmail])
            case .feedback:
                    mailer.setToRecipients([feedbackEmail])
            default:
                break
            }
            mailer.setSubject(subjectField.text ?? "")
            mailer.setMessageBody(messageField.text ?? "", isHTML: false)
            self.present(mailer, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Error", message: "Please have the default mail client installed.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
