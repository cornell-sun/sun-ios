//
//  SearchSectionController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 2/4/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

enum SearchCellType: Int {
    case categoryCell = 0
    case titleCell = 1
    case previewCell = 2
}

class SearchSectionController: ListSectionController {
    let CATEGORYCELLHEIGHT: CGFloat = 40
    let PREVIEWCELLHEIGHT: CGFloat = 100

    var entry: PostObject!
    weak var delegate: TabBarViewControllerDelegate?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }

    override func numberOfItems() -> Int {
        return 3
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        guard let sizeForItemIndex = SearchCellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .categoryCell:
            return CGSize(width: width, height: CATEGORYCELLHEIGHT)
        case .titleCell:
            let height = entry.title.height(withConstrainedWidth: width - 34, font: .articleTitle) //CLUTCH Extension thank stackoverflow gods
            return CGSize(width: width, height: height + 10)
        case .previewCell:
            return CGSize(width: width, height: PREVIEWCELLHEIGHT)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cellForItemIndex = SearchCellType(rawValue: index) else {
            return UICollectionViewCell()
        }

        switch cellForItemIndex {
        case .categoryCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: CategoryCell.self, for: self, at: index) as! CategoryCell
            cell.post = entry
            cell.layoutMargins = .zero
            return cell
        case .titleCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: TitleCell.self, for: self, at: index) as! TitleCell
            cell.post = entry
            cell.layoutMargins = .zero
            return cell
        case .previewCell:
            if entry.featuredMediaImages?.thumbnail?.url != nil {
                // swiftlint:disable:next force_cast
                let cell = collectionContext!.dequeueReusableCell(of: SearchCell.self, for: self, at: index) as! SearchCell
                cell.post = entry
                cell.layoutMargins = .zero
                return cell
            } else {
                // swiftlint:disable:next force_cast
                let cell = collectionContext!.dequeueReusableCell(of: SearchCellNoImage.self, for: self, at: index) as! SearchCellNoImage
                cell.post = entry
                cell.layoutMargins = .zero
                return cell
            }
        }
    }

    override func didUpdate(to object: Any) {
        entry = object as? PostObject
    }

    override func didSelectItem(at index: Int) {
        delegate?.articleSectionDidPressOnArticle(entry)
    }
}
