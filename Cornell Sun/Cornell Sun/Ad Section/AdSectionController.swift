//
//  AdSectionController.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 2/24/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

enum AdCellType: Int {
    case categoryCell = 0
    case adImageCell = 1
}

class AdSectionController: ListSectionController {
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension AdSectionController {
    
    override func numberOfItems() -> Int {
        return 2
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {return .zero}
        let width = context.containerSize.width
        guard let sizeForItemIndex = AdCellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .categoryCell:
            return CGSize(width: width, height: 40)
        case .adImageCell:
            return CGSize(width: width, height: width*0.8333)
        }
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cellForItemIndex = AdCellType(rawValue: index) else {
            return UICollectionViewCell()
        }
        switch cellForItemIndex {
        case .categoryCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: CategoryCell.self, for: self, at: index) as! CategoryCell
            cell.adLabel = "Sponsored"
            return cell
        case .adImageCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: AdImageCell.self, for: self, at: index) as! AdImageCell
            cell.loadAd()
            return cell
        }
    }
}
