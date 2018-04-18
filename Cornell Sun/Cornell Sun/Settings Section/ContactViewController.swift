//
//  ContactViewController.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 3/23/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, UITextFieldDelegate, MFMailComposeViewControllerDelegate {
    
    var prevViewController: UIViewController!
    var titleCache: String!
    var type: SettingType!
    
    var headerLabel: UILabel!
    var descriptionTextView: UITextView!
    var actionButton: UIButton!
    var subjectField: UITextField!
    var emailField: UITextField!
    var messageField: UITextField!
    
    let contactEmail = "news@cornellsun.com"
    let feedbackEmail = "feedback@cornellsun.com"
    
    let headerHeight: CGFloat = 43
    let headerOffset: CGFloat = 86.5
    let descriptionHeight: CGFloat = 58
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
    let buttonOffset: CGFloat = 56.5
    
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
        let navBar = navigationController?.navigationBar
//        if #available(iOS 11.0, *) {
//            navBar?.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .never
//        } else {
//            // Fallback on earlier versions
//        }
        //navBar?.barTintColor = .white
        //navBar?.tintColor = .black
        navBar?.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
        navBar?.shadowImage = UIColor.lightGray.as1ptImage()
        self.title = ""
        let widthScale = view.frame.width/screenWidth //Scaling width
        //let heightScale = view.frame.height/screenWidth //Scaling height
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
        descriptionTextView.font = UIFont(name:"HelveticaNeue", size: 16.0)
        //descriptionTextView.font?.withSize(16.0)
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        view.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(descriptionHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(headerLabel.snp.bottom).offset(descriptionOffset)
        }
        
        let subjectLabel = UILabel()
        subjectLabel.text = "Subject"
        subjectLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        subjectLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        view.addSubview(subjectLabel)
        subjectLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(labelOffsetTop)
        }
        subjectField = UITextField()
        subjectField.borderStyle = UITextBorderStyle.none
        subjectField.delegate = self
        subjectField.font = UIFont(name:"HelveticaNeue", size: 18.0)
        view.addSubview(subjectField)
        subjectField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(textHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(subjectLabel.snp.bottom).offset(labelOffsetBottom)
        }
        let subjectBorder = CALayer()
        let width = CGFloat(1.0)
        subjectBorder.borderColor = UIColor(red: 217/256, green: 217/256, blue: 217/256, alpha: 1).cgColor
        subjectBorder.frame = CGRect(x: 0, y: textHeight - width, width:  textWidth*widthScale+2.0, height: textHeight+2)
        subjectBorder.borderWidth = width
        subjectField.layer.addSublayer(subjectBorder)
        subjectField.layer.masksToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        nameLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(subjectField.snp.bottom).offset(labelOffsetTop)
        }
        let nameField = UITextField()
        nameField.borderStyle = UITextBorderStyle.none
        nameField.delegate = self
        nameField.font = UIFont(name:"HelveticaNeue", size: 18.0)
        view.addSubview(nameField)
        nameField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(textHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(nameLabel.snp.bottom).offset(labelOffsetBottom)
        }
        let nameBorder = CALayer()
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
        emailField.delegate = self
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
        
        let messageLabel = UILabel()
        messageLabel.text = "Message"
        messageLabel.font = UIFont(name:"HelveticaNeue", size: 14.0)
        messageLabel.textColor = UIColor(red: 155/256, green: 155/256, blue: 155/256, alpha: 1)
        view.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(labelHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(emailField.snp.bottom).offset(labelOffsetTop)
        }
        messageField = UITextField()
        messageField.borderStyle = UITextBorderStyle.none
        messageField.delegate = self
        messageField.font = UIFont(name:"HelveticaNeue", size: 18.0)
        view.addSubview(messageField)
        messageField.snp.makeConstraints { make in
            make.width.equalTo(textWidth*widthScale)
            make.height.equalTo(messageHeight)
            make.centerX.equalTo(view.center.x)
            make.top.equalTo(messageLabel.snp.bottom).offset(labelOffsetBottom)
        }
        let messageBorder = CALayer()
        messageBorder.borderColor = UIColor(red: 217/256, green: 217/256, blue: 217/256, alpha: 1).cgColor
        messageBorder.frame = CGRect(x: 0, y: messageHeight - width, width:  textWidth*widthScale+2.0, height: messageHeight+2)
        messageBorder.borderWidth = width
        messageField.layer.addSublayer(messageBorder)
        messageField.layer.masksToBounds = true
        
        actionButton = UIButton()
        actionButton.backgroundColor = UIColor.white// (red: 238/255, green: 68/255, blue: 68/255, alpha: 1)
        actionButton.layer.cornerRadius = 20
        let bigRed = UIColor(red: 179/255, green: 27/255, blue: 27/255, alpha: 1)
        actionButton.layer.borderWidth = 2.5
        actionButton.layer.borderColor = bigRed.cgColor
        actionButton.setTitle("Send", for: .normal)
        actionButton.setTitleColor(bigRed, for: .normal)
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.width.equalTo(buttonWidth)
            make.height.equalTo(buttonHeight)
            make.bottom.equalTo(view.snp.bottom).offset(-buttonOffset)
            make.centerX.equalTo(view.center.x)
        }
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
            switch type {
                case .contactus:
                        mailer.setToRecipients([contactEmail])
                case .feedback:
                        mailer.setToRecipients([feedbackEmail])
                default:
                    break
            }
            mailer.setSubject(subjectField.text!)
            mailer.setMessageBody(messageField.text!, isHTML: false)
            self.present(mailer, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Cannot send email right now", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
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
