//
//  BookmarkSectionController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/13/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import ImageSlideshow

// swiftlint:disable:next type_name
enum bookmarkCellType: Int {
    case categoryCell = 0
    case imageAndTitleCell = 1
    case actionMenuCell = 2
}

class BookmarkSearchSectionController: ListSectionController {
    var entry: PostObject!
    var forBookmarks: Bool!
    weak var delegate: TabBarViewControllerDelegate?

    init(forBookmarks: Bool = false) {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        self.forBookmarks = forBookmarks
    }
}

extension BookmarkSearchSectionController: BookmarkPressedDelegate, SharePressedDelegate {

    func taptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
    }

    func didPressBookmark(_ cell: MenuActionCell) {
        pressedBookmark(cell, entry: entry)
    }

    func didPressShare() {
        pressedShare(entry: entry)
    }

    func didPressPhotos(_ slideShow: ImageSlideshow) {
        let fullScreenVC = FullScreenSlideshowViewController()
        slideShow.contentScaleMode = .scaleAspectFit
        slideShow.zoomEnabled = true
        fullScreenVC.slideshow = slideShow
        getCurrentViewController()?.present(fullScreenVC, animated: true, completion: nil)
    }

    override func numberOfItems() -> Int {
        return 3
    }
//
    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        guard let sizeForItemIndex = bookmarkCellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .categoryCell:
            return CGSize(width: width, height: 45)
        case .imageAndTitleCell:
            return CGSize(width: width, height: 124)
        case .actionMenuCell:
            return CGSize(width: width, height: 40)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cellForItemIndex = bookmarkCellType(rawValue: index) else {
            return UICollectionViewCell()
        }
        switch cellForItemIndex {
        case .categoryCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: CategoryCell.self, for: self, at: index) as! CategoryCell
            cell.post = entry
            return cell
        case .imageAndTitleCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: BookmarkCell.self, for: self, at: index) as! BookmarkCell
            cell.post = entry
            return cell
        case .actionMenuCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: MenuActionCell.self, for: self, at: index) as! MenuActionCell
            cell.bookmarkDelegate = self
            cell.shareDelegate = self
            cell.post = entry
            cell.setupViews(forBookmarks: forBookmarks)
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        entry = object as? PostObject
    }

    override func didSelectItem(at index: Int) {
        if bookmarkCellType(rawValue: index) != .actionMenuCell {
            delegate?.articleSectionDidPressOnArticle(entry)
        }
    }
}
