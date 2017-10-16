//
//  SpinnerCell.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/22/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

func spinnerSectionController() -> ListSingleSectionController {
    let configureBlock = { (item: Any, cell: UICollectionViewCell) in
        guard let cell = cell as? SpinnerCell else { return }
        cell.activityIndicator.startAnimating()
    }

    let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
        guard let context = context else { return .zero }
        return CGSize(width: context.containerSize.width, height: 100)
    }

    return ListSingleSectionController(cellClass: SpinnerCell.self,
                                       configureBlock: configureBlock,
                                       sizeBlock: sizeBlock)
}

final class SpinnerCell: UICollectionViewCell {

    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.contentView.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        let bounds = contentView.bounds
        activityIndicator.center = CGPoint(x: bounds.midX, y: bounds.midY)
    }

}
