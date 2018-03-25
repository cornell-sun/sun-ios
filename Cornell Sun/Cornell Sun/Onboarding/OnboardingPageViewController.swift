//
//  OnboardingPageViewController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 3/19/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {

    var pageControl: UIPageControl!
    var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        pages = [OnboardingViewController(type: .welcome), OnboardingViewController(type: .getStarted)]
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
        delegate = self
        dataSource = self

        pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .offWhite
        pageControl.pageIndicatorTintColor = .darkGrey
        pageControl.numberOfPages = pages.count
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(50)
        }
    }

    @objc func pageNextTapped(_ sender: UIButton) {
        if let viewController = viewControllers?.first, let index = pages.index(of: viewController), index < pages.count - 1 {
            setViewControllers([pages[index + 1]], direction: .forward, animated: true, completion: nil)
            pageControl.currentPage = index + 1
        }
    }

    @objc func pageBackTapped(_ sender: UIButton) {
        if let viewController = viewControllers?.first, let index = pages.index(of: viewController), index != 0 {
            setViewControllers([pages[index - 1]], direction: .reverse, animated: true, completion: nil)
            pageControl.currentPage = index - 1
        }
    }

    @objc func dismissOnboarding() {
        let userDefaults = UserDefaults.standard
        userDefaults.setValue(true, forKey: hasOnboardedKey)
        dismiss(animated: true, completion: nil)
    }

}

extension OnboardingPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController), index != 0 {
            return pages[index - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = pages.index(of: viewController), index < pages.count - 1 {
            return pages[index + 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let viewControllers = pageViewController.viewControllers, let index = pages.index(of: viewControllers[0]) {
            pageControl.currentPage = index
        }
    }

}
