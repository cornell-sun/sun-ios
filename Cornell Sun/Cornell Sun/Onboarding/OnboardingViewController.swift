//
//  OnboardingViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 3/19/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

enum OnboardingViewControllerType {
    case welcome
    case getStarted

    var titleString: String {
        switch self {
        case .welcome:
            return "Welcome to The Cornell Daily Sun"
        case .getStarted:
            return "Let's get started"
        }
    }

    var descriptionString: String {
        switch self {
        case .welcome:
            return "Here's a description"
        case .getStarted:
            return "It's lit"
        }
    }

    var indexInPages: Int {
        switch self {
        case .welcome:
            return 0
        case .getStarted:
            return 1
        }
    }
}

class OnboardingViewController: UIViewController {

    var onboardingType: OnboardingViewControllerType!
    var onboardingImageView: UIImageView?
    var onboardingTitleLabel: UILabel!
    var onboardingDescriptionLabel: UILabel!
    var nextButton: UIButton!
    var backButton: UIButton!

    init(type: OnboardingViewControllerType) {
        super.init(nibName: nil, bundle: nil)
        onboardingType = type
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .bigRed

        onboardingTitleLabel = UILabel()
        onboardingTitleLabel.textColor = .white
        onboardingTitleLabel.textAlignment = .center
        view.addSubview(onboardingTitleLabel)
        onboardingTitleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().inset(16)
        }

        onboardingDescriptionLabel = UILabel()
        onboardingDescriptionLabel.textColor = .white
        onboardingDescriptionLabel.textAlignment = .center
        view.addSubview(onboardingDescriptionLabel)
        onboardingDescriptionLabel.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(onboardingTitleLabel.snp.bottom).offset(24)
        }

        nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(nil, action: #selector(OnboardingPageViewController.pageNextTapped(_:)), for: .touchUpInside)
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.equalTo(onboardingDescriptionLabel.snp.centerX).offset(6)
            make.top.equalTo(onboardingDescriptionLabel.snp.bottom).offset(24)
            make.width.equalTo(48)
            make.height.equalTo(24)
        }

        backButton = UIButton()
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(nil, action: #selector(OnboardingPageViewController.pageBackTapped(_:)), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.trailing.equalTo(onboardingDescriptionLabel.snp.centerX).inset(6)
            make.top.equalTo(onboardingDescriptionLabel.snp.bottom).offset(24)
            make.width.equalTo(48)
            make.height.equalTo(24)
        }

        configureOnboarding()
    }

    private func configureOnboarding() {
        onboardingTitleLabel.text = onboardingType.titleString
        onboardingDescriptionLabel.text = onboardingType.descriptionString
        if onboardingType.indexInPages == 0 {
            backButton.isHidden = true
        } else if onboardingType.indexInPages == 1 {
            nextButton.setTitle("Finish", for: .normal)
            nextButton.addTarget(nil, action: #selector(OnboardingPageViewController.dismissOnboarding), for: .touchUpInside)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
