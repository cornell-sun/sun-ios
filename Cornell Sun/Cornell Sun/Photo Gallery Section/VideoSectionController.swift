//
//  VideoSectionController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/26/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

fileprivate enum VideoCellType: Int {
    case categoryCell = 0
    case titleCell = 1
    case videoCell = 2
    case actionMenuCell = 3

}

class VideoSectionController: ListSectionController {
    var entry: PostObject!

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension VideoSectionController: BookmarkPressedDelegate, SharePressedDelegate {

    func didPressBookmark(_ cell: MenuActionCell) {
        pressedBookmark(cell, entry: entry)
    }

    func didPressShare() {
        pressedShare(entry: entry)
    }

    override func numberOfItems() -> Int {
        return 4
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        guard let sizeForItemIndex = VideoCellType(rawValue: index) else {
            return .zero
        }

        switch sizeForItemIndex {
        case .categoryCell:
            return CGSize(width: width, height: 45)
        case .titleCell:
            let height = entry.title.height(withConstrainedWidth: width - 34, font: .articleTitle, lineSpacing: 4.5) //CLUTCH Extension thank stackoverflow gods
            return CGSize(width: width, height: height + 20)
        case .videoCell:
            return CGSize(width: width, height: width / 1.5)
        case .actionMenuCell:
            return CGSize(width: width, height: 50)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cellForItemIndex = VideoCellType(rawValue: index) else {
            return UICollectionViewCell()
        }

        switch cellForItemIndex {
        case .categoryCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: CategoryCell.self, for: self, at: index) as! CategoryCell
            cell.post = entry
            return cell
        case .titleCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: TitleCell.self, for: self, at: index) as! TitleCell
            cell.post = entry
            return cell
        case .videoCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: VideoCell.self, for: self, at: index) as! VideoCell
            cell.post = entry
            return cell
        case .actionMenuCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: MenuActionCell.self, for: self, at: index) as! MenuActionCell
            cell.bookmarkDelegate = self
            cell.shareDelegate = self
            cell.post = entry
            cell.setupViews(forBookmarks: false)
            cell.setBookmarkImage(didSelectBookmark: entry.didSave)
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        entry = object as? PostObject
    }
}
