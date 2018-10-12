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
    case notifications

    var titleString: String {
        switch self {
        case .welcome:
            return "Welcome to The Cornell Daily Sun"
        case .notifications:
            return "Stay up to date with Breaking News"
        }
    }

    var descriptionString: String {
        switch self {
        case .welcome:
            return "The oldest independent student newspaper by Cornellians, for Cornellians"
        case .notifications:
            return "We’ll only send you the most important stories. You can customize this later on."
        }
    }

    var indexInPages: Int {
        switch self {
        case .welcome:
            return 0
        case .notifications:
            return 1
        }
    }

    var image: UIImage {
        switch self {
        case .welcome:
            return #imageLiteral(resourceName: "clockTower")
        case .notifications:
            return UIImage(named: "notificationsAndChairLarge")!
        }
    }

    // For 5/SE screen size
    var smallImage: UIImage {
        switch self {
        case .welcome:
            return UIImage(named: "clockTower")!
        case .notifications:
            return UIImage(named: "notificationsAndChairSmall")!
        }
    }
}

class OnboardingViewController: UIViewController {

    var onboardingType: OnboardingViewControllerType!
    var onboardingImageView: UIImageView!
    var onboardingTitleLabel: UILabel!
    var onboardingDescriptionLabel: UILabel!

    let padding: CGFloat = 50
    let topOffset: CGFloat = 90
    let descriptionTopOffset: CGFloat = 10

    init(type: OnboardingViewControllerType) {
        super.init(nibName: nil, bundle: nil)
        onboardingType = type
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brick
        let backgroundGradientView = UIImageView()
        backgroundGradientView.image = #imageLiteral(resourceName: "gradient")
        view.addSubview(backgroundGradientView)
        backgroundGradientView.snp.makeConstraints { $0.edges.equalToSuperview() }

        onboardingTitleLabel = UILabel()
        onboardingTitleLabel.numberOfLines = 0
        onboardingTitleLabel.textColor = .white
        onboardingTitleLabel.textAlignment = .left
        onboardingTitleLabel.font = .systemFont(ofSize: 27, weight: .bold)

        onboardingDescriptionLabel = UILabel()
        onboardingDescriptionLabel.textColor = .white
        onboardingDescriptionLabel.textAlignment = .left
        onboardingDescriptionLabel.numberOfLines = 0
        onboardingDescriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)

        onboardingImageView = UIImageView()
        onboardingImageView.clipsToBounds = true
        onboardingImageView.contentMode = .scaleAspectFit

        view.addSubview(onboardingImageView)
        view.addSubview(onboardingDescriptionLabel)
        view.addSubview(onboardingTitleLabel)

        setupConstraints()

        configureOnboarding()
    }

    func setupConstraints() {
        var bottomArea = view.layoutMarginsGuide.snp.bottom
        if #available(iOS 11, *) {
            bottomArea = view.safeAreaLayoutGuide.snp.bottom
        }

        onboardingTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topOffset)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        onboardingDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(onboardingTitleLabel.snp.bottom).offset(descriptionTopOffset)
            make.leading.trailing.equalToSuperview().inset(padding)
        }

        onboardingImageView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomArea).inset(padding)
            make.top.equalTo(view.snp.centerY).offset(-view.frame.height * 0.1)
        }

    }

    private func configureOnboarding() {
        onboardingTitleLabel.text = onboardingType.titleString
        onboardingDescriptionLabel.text = onboardingType.descriptionString
        if UIScreen.main.bounds.width <= 350 {
            onboardingImageView.image = onboardingType.smallImage
        } else {
            onboardingImageView.image = onboardingType.image
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
