//
//  OnboardingTableViewCell.swift
//  Cornell Sun
//
//  Created by Cameron Hamidi on 11/23/20.
//  Copyright © 2020 cornell.sun. All rights reserved.
//

import SnapKit
import UIKit

class OnboardingSectionsViewController: UIViewController {

    let descriptionLabel = UILabel()
    let nextButton = UIButton()
    let sections = Sections.allSections
    let tableView = UITableView()
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
        titleLabel.text = "Stay up to date with Breaking News"
        view.addSubview(titleLabel)

        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIScreen.main.bounds.width <= 350
            ? .systemFont(ofSize: 14, weight: .medium)
            : .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.text = "Choose topics that interest you and get relevant updates"
        view.addSubview(descriptionLabel)

        tableView.register(OnboardingTableViewCell.self, forCellReuseIdentifier: OnboardingTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        view.addSubview(tableView)

        nextButton.backgroundColor = .white
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        view.addSubview(nextButton)

        setupConstraints()
    }

    @objc func nextButtonPressed() {
        delegate?.pageNextTapped()
    }

    func setupConstraints() {
        let descriptionTopOffset: CGFloat = 10
        let nextButtonBottom: CGFloat = UIScreen.main.bounds.width <= 350
            ? -86
            : -86
        let nextButtonHeight: CGFloat = UIScreen.main.bounds.width <= 350
            ? 44
            : 54
        let nextButtonPadding: CGFloat = UIScreen.main.bounds.width <= 350
            ? 33
            : 43
        let padding: CGFloat = 50
        let tableViewBottom: CGFloat = UIScreen.main.bounds.width <= 350
            ? -33
            : -53
        let tableViewTop: CGFloat = UIScreen.main.bounds.width <= 350
            ? 30
            : 40
        let titleLabelTop: CGFloat = 45

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(titleLabelTop)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(descriptionTopOffset)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(tableViewTop)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(tableViewBottom)
        }

        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(nextButtonPadding)
            make.trailing.equalToSuperview().offset(-nextButtonPadding)
            make.bottom.equalToSuperview().offset(nextButtonBottom)
            make.height.equalTo(nextButtonHeight)
        }
    }

}

extension OnboardingSectionsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: OnboardingTableViewCell.identifier) as! OnboardingTableViewCell
        let isLastRow = indexPath.row == sections.count - 1
        cell.configure(for: sections[indexPath.row], isLastRow: isLastRow)
        return cell
    }

}

extension OnboardingSectionsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return OnboardingTableViewCell.height
    }

}
