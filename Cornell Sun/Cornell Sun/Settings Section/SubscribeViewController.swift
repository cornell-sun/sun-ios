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
    var firstNameField: UITextField!
    var lastNameField: UITextField!
    var iAmAField: UITextField!
    var pickerView: UIPickerView!
    var emailBorder: UIView!
    var firstNameBorder: UIView!
    var lastNameBorder: UIView!
    var iAmABorder: UIView!

    var pickerIndexSelected = 0

    let descriptionPadding: CGFloat = 30.0
    let descriptionHeight: CGFloat = 117.0
    let headerHeight: CGFloat = 43
    let headerOffset: CGFloat = 22.5
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

    var didLayout = false

    override func viewWillAppear(_ animated: Bool) {
        titleCache = prevViewController.title
        prevViewController.title = "Settings"
    }

    override func viewWillDisappear(_ animated: Bool) {
        prevViewController.title = titleCache
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if !didLayout {
            let widthScale = view.frame.width/screenWidth //Scaling width
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

            let fixedWidth = view.bounds.width - 2*descriptionPadding
            let newSize = descriptionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

            descriptionTextView.snp.makeConstraints { make in
                make.leading.equalTo(descriptionPadding)
                make.trailing.equalToSuperview().inset(descriptionPadding)
                make.height.equalTo(newSize.height)
                make.top.equalTo(headerLabel.snp.bottom)
            }

            emailField.snp.makeConstraints { make in
                make.width.equalTo(descriptionTextView.snp.width)
                make.height.equalTo(textHeight)
                make.centerX.equalToSuperview()
                make.top.equalTo(descriptionTextView.snp.bottom).offset(30)
            }

            firstNameField.snp.makeConstraints { make in
                make.width.equalTo(descriptionTextView.snp.width)
                make.height.equalTo(textHeight)
                make.centerX.equalToSuperview()
                make.top.equalTo(emailBorder.snp.bottom).offset(headerHeight)
            }

            lastNameField.snp.makeConstraints { make in
                make.width.equalTo(descriptionTextView.snp.width)
                make.height.equalTo(textHeight)
                make.centerX.equalToSuperview()
                make.top.equalTo(firstNameBorder.snp.bottom).offset(headerHeight)
            }

            iAmAField.snp.makeConstraints { make in
                make.width.equalTo(descriptionTextView.snp.width)
                make.height.equalTo(textHeight)
                make.centerX.equalToSuperview()
                make.top.equalTo(lastNameBorder.snp.bottom).offset(headerHeight)
            }
            actionButton.snp.makeConstraints { make in
                make.width.equalTo(buttonWidth)
                make.height.equalTo(buttonHeight)
                make.bottom.equalTo(bottomArea).offset(-buttonOffset)
                make.centerX.equalTo(view.center.x)
            }

            didLayout = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = ""
        headerLabel = UILabel()
        headerLabel.text = "Daily Newsletters"
        headerLabel.textColor = .black
        headerLabel.font = .systemFont(ofSize: 36, weight: .bold)
        headerLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(headerLabel)

        descriptionTextView = UITextView()
        let descriptionText = "Get Daily Sun headlines delivered to your inbox every day. You'll never miss a moment."
        descriptionTextView.text = descriptionText
        descriptionTextView.textColor = .black
        descriptionTextView.font = .systemFont(ofSize: 16)
        descriptionTextView.isEditable = false
        descriptionTextView.isScrollEnabled = false
        view.addSubview(descriptionTextView)

        emailField = UITextField()
        emailField.placeholder = "Email"
        emailField.borderStyle = .none
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        emailField.delegate = self
        view.addSubview(emailField)

        emailBorder = UIView()
        emailBorder.backgroundColor = .subscribeTextField
        view.addSubview(emailBorder)
        emailBorder.snp.makeConstraints { make in
            make.leading.trailing.equalTo(emailField)
            make.height.equalTo(1)
            make.top.equalTo(emailField.snp.bottom).offset(3)
        }

        firstNameField = UITextField()
        firstNameField.placeholder = "First Name"
        firstNameField.borderStyle = .none
        firstNameField.delegate = self
        view.addSubview(firstNameField)

        firstNameBorder = UIView()
        firstNameBorder.backgroundColor = .subscribeTextField
        view.addSubview(firstNameBorder)
        firstNameBorder.snp.makeConstraints { make in
            make.leading.trailing.equalTo(firstNameField)
            make.height.equalTo(1)
            make.top.equalTo(firstNameField.snp.bottom).offset(3)
        }

        lastNameField = UITextField()
        lastNameField.placeholder = "Last Name"
        lastNameField.borderStyle = .none
        lastNameField.delegate = self
        view.addSubview(lastNameField)

        lastNameBorder = UIView()
        lastNameBorder.backgroundColor = .subscribeTextField
        view.addSubview(lastNameBorder)
        lastNameBorder.snp.makeConstraints { make in
            make.leading.trailing.equalTo(lastNameField)
            make.height.equalTo(1)
            make.top.equalTo(lastNameField.snp.bottom).offset(3)
        }

        pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self

        iAmAField = UITextField()
        iAmAField.placeholder = "I am a:"
        iAmAField.borderStyle = .none
        iAmAField.inputView = pickerView
        iAmAField.delegate = self
        view.addSubview(iAmAField)

        iAmABorder = UIView()
        iAmABorder.backgroundColor = .subscribeTextField
        view.addSubview(iAmABorder)
        iAmABorder.snp.makeConstraints { make in
            make.leading.trailing.equalTo(iAmAField)
            make.height.equalTo(1)
            make.top.equalTo(iAmAField.snp.bottom).offset(3)
        }

        actionButton = UIButton()
        actionButton.backgroundColor = UIColor.white// (red: 238/255, green: 68/255, blue: 68/255, alpha: 1)
        actionButton.layer.cornerRadius = buttonHeight / 2.0
        let bigRed = UIColor(red: 179/255, green: 27/255, blue: 27/255, alpha: 1)
        actionButton.layer.borderWidth = 2.5
        actionButton.layer.borderColor = bigRed.cgColor
        actionButton.setTitle("Subscribe", for: .normal)
        actionButton.setTitleColor(bigRed, for: .normal)
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        actionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(actionButton)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let itemSelected = pickerList[row]
        iAmAField.text = itemSelected
        pickerIndexSelected = row
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

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == iAmAField {
            pickerView(pickerView, didSelectRow: pickerIndexSelected, inComponent: 0)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @objc func buttonAction() {
        guard
            let email = emailField.text,
            let firstName = firstNameField.text,
            let lastName = lastNameField.text,
            !email.isEmpty, !firstName.isEmpty, !lastName.isEmpty else { return }

        API.mailchimpProvider.request(.subscribe(firstname: firstName, lastname: lastName, email: email)) { _ in
            let alert = UIAlertController(title: "Thank You For Subscribing!", message: "Please check your email to confirm your subscription", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            self.emailField.text = ""
            self.firstNameField.text = ""
            self.lastNameField.text = ""
            self.iAmAField.text = ""

        }

    }
}
