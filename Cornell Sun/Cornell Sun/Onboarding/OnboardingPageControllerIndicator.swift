//
//  OnboardingPageControllerIndicator.swift
//  Cornell Sun
//
//  Created by Cameron Hamidi on 11/21/20.
//  Copyright © 2020 cornell.sun. All rights reserved.
//

import SnapKit
import UIKit

class OnboardingPageControllerIndicator: UIView {

    let cellHeight: CGFloat = 5
    let cellIdentifier = "onboardingCellIdentifier"
    let cellSpacing: CGFloat = 10
    let cellWidth: CGFloat = 30
    let collectionView: UICollectionView!

    var cellCount = 0
    var selectedCell = 0

    init(_ cellCount: Int) {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.minimumInteritemSpacing = cellSpacing
        collectionViewLayout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)

        super.init(frame: .zero)

        self.cellCount = cellCount

        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        backgroundColor = .clear
        collectionView.backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getWidth() -> CGFloat {
        return (cellWidth + cellSpacing) * CGFloat(cellCount) - cellSpacing
    }

    func selectCell(at cell: Int) {
        guard cell >= 0 && cell < cellCount else { return }

        let previousCell = collectionView.cellForItem(at: IndexPath(item: selectedCell, section: 0))
        previousCell?.backgroundColor = .onboardingPageControllerDeselected

        selectedCell = cell
        let newCell = collectionView.cellForItem(at: IndexPath(item: selectedCell, section: 0))
        newCell?.backgroundColor = .white
    }

}

extension OnboardingPageControllerIndicator: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = indexPath.row == selectedCell ? .white : .onboardingPageControllerDeselected
        cell.layer.cornerRadius = cellHeight / 2.0
        return cell
    }

}

extension OnboardingPageControllerIndicator: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }

}
