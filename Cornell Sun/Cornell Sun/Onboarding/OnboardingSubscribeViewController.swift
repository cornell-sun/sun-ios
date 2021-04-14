//
//  OnboardingSubscribeViewController.swift
//  Cornell Sun
//
//  Created by Cameron Hamidi on 11/24/20
//  Copyright © 2020 cornell.sun. All rights reserved.
//

import SnapKit
import UIKit

class OnboardingSubscribeViewController: UIViewController {

    let descriptionLabel = UILabel()
    let infoTableView = UITableView()
    let notNowButton = UIButton()
    let subscribeButton = UIButton()
    let titleLabel = UILabel()

    weak var delegate: OnboardingPageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.onboardingGradientTop.cgColor, UIColor.onboardingGradientBottom.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)

        titleLabel.numberOfLines = 0
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.font = UIScreen.main.bounds.width <= 350
            ? .systemFont(ofSize: 21, weight: .bold)
            : .systemFont(ofSize: 27, weight: .bold)
        titleLabel.text = "Subscribe to Our Daily Newsletters"
        view.addSubview(titleLabel)

        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIScreen.main.bounds.width <= 350
            ? .systemFont(ofSize: 14, weight: .medium)
            : .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.text = "Get headlines delivered to your inbox everyday. You’ll never miss a moment."
        view.addSubview(descriptionLabel)

        infoTableView.register(OnboardingSubscribeInfoTableViewCell.self, forCellReuseIdentifier: OnboardingSubscribeInfoTableViewCell.identifier)
        infoTableView.backgroundColor = .clear
        infoTableView.dataSource = self
        infoTableView.delegate = self
        infoTableView.separatorStyle = .none
        infoTableView.isScrollEnabled = false
        view.addSubview(infoTableView)

        subscribeButton.backgroundColor = .white
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.setTitleColor(.black, for: .normal)
        subscribeButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        subscribeButton.layer.cornerRadius = 10
        subscribeButton.addTarget(self, action: #selector(subscribeButtonTapped), for: .touchUpInside)
        view.addSubview(subscribeButton)

        let buttonAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white,
            .underlineStyle: 1]
        let attributedString = NSAttributedString(string: "Not Now", attributes: buttonAttributes)
        notNowButton.setAttributedTitle(attributedString, for: .normal)
//        notNowButton.setAttributedTitle(NSAttributedString(string: "Hello There"), for: .normal)
        notNowButton.addTarget(self, action: #selector(dismissPageController), for: .touchUpInside)
        view.addSubview(notNowButton)

        setupConstraints()
    }

    @objc func dismissPageController() {
        delegate?.pageNextTapped()
    }

    @objc func subscribeButtonTapped() {
        guard let firstnameCell = infoTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? OnboardingSubscribeInfoTableViewCell, let firstName = firstnameCell.textField.text else {
            return
        }

        guard let lastnamecell = infoTableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? OnboardingSubscribeInfoTableViewCell, let lastName = lastnamecell.textField.text else {
            return
        }

        guard let emailcell = infoTableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? OnboardingSubscribeInfoTableViewCell, let email = emailcell.textField.text else {
            return
        }

        if firstName == "" || lastName == "" || email == "" {
            return
        }

        API.mailchimpProvider.request(.subscribe(firstname: firstName, lastname: lastName, email: email)) { _ in
            let alert = UIAlertController(title: "Thank You For Subscribing!", message: "Please check your email to confirm your subscription", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        delegate?.pageNextTapped()
    }

    func setupConstraints() {
        let descriptionTopOffset: CGFloat = 10
        let notNowButtonBottom: CGFloat = 10
        let padding: CGFloat = 50
        let subscribeButtonBottom: CGFloat = UIScreen.main.bounds.width <= 350
            ? -86
            : -86
        let subscribeButtonHeight: CGFloat = UIScreen.main.bounds.width <= 350
            ? 44
            : 54
        let subscribeButtonPadding: CGFloat = UIScreen.main.bounds.width <= 350
            ? 33
            : 43
        let tableViewBottom: CGFloat = UIScreen.main.bounds.width <= 350
            ? 0
            : -79
        let tableViewPadding: CGFloat = 42
        let tableViewTop: CGFloat = UIScreen.main.bounds.width <= 350
            ? 5
            : 21
        let titleLabelTop: CGFloat = 45

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(titleLabelTop)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(descriptionTopOffset)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        infoTableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(tableViewTop)
            make.leading.equalToSuperview().offset(tableViewPadding)
            make.trailing.equalToSuperview().offset(-tableViewPadding)
            make.bottom.equalTo(subscribeButton.snp.top).offset(tableViewBottom)
        }

        subscribeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(subscribeButtonPadding)
            make.trailing.equalToSuperview().offset(-subscribeButtonPadding)
            make.bottom.equalToSuperview().offset(subscribeButtonBottom)
            make.height.equalTo(subscribeButtonHeight)
        }

        notNowButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subscribeButton.snp.bottom).offset(notNowButtonBottom)
        }
    }

}

extension OnboardingSubscribeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OnboardingSubscribeSections.getSections().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingSubscribeInfoTableViewCell.identifier) as! OnboardingSubscribeInfoTableViewCell
        let section = OnboardingSubscribeSections.getSections()[indexPath.row]
        cell.configure(for: section)
        return cell
    }

}

extension OnboardingSubscribeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OnboardingSubscribeInfoTableViewCell.height
    }

}
