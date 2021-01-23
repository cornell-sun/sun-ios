//
//  HeroSectionController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/13/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import ImageSlideshow

// swiftlint:disable:next type_name
enum heroCellType: Int {
    case imageCell = 0
    case titleCell = 1
    case authorCell = 2
    case taglineCell = 3
    case actionMenuCell = 4
}

class HeroSectionController: ListSectionController {
    var entry: PostObject!
    weak var delegate: TabBarViewControllerDelegate?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension HeroSectionController: BookmarkPressedDelegate, SharePressedDelegate {

    func didPressBookmark(_ cell: MenuActionCell) {
        pressedBookmark(cell, entry: entry)
    }

    func didPressShare() {
        pressedShare(entry: entry)
    }

    override func numberOfItems() -> Int {
        return 5
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero }
        let width = context.containerSize.width
        guard let sizeForItemIndex = heroCellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .imageCell:
            return CGSize(width: width, height: width / 1.5)
        case .titleCell:
            let height = entry.title.height(withConstrainedWidth: width - 36, font: .articleTitle, lineSpacing: 5) //CLUTCH Extension thank stackoverflow gods
            return CGSize(width: width, height: height + 15)
        case .authorCell:
            let height = entry.author?.byline.height(withConstrainedWidth: width, font: .subSecondaryHeader) ?? 0
            return CGSize(width: width, height: height + 10)
        case .taglineCell:
            let lineHeight: CGFloat = UIFont.photoCaption.lineHeight * 4.0
            let height: CGFloat = entry.excerpt.removingHTMLEntities().height(withConstrainedWidth: width, font: .photoCaption)
            let correctHeight = lineHeight <= height ? lineHeight : height
            return CGSize(width: width, height: correctHeight)
        case .actionMenuCell:
            return CGSize(width: width, height: 40)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cellForItemIndex = heroCellType(rawValue: index) else {
            return UICollectionViewCell()
        }
        switch cellForItemIndex {
        case .imageCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as! ImageCell
            cell.post = entry
            return cell
        case .titleCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: TitleCell.self, for: self, at: index) as! TitleCell
            cell.post = entry
            return cell
        case .authorCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: AuthorCell.self, for: self, at: index) as! AuthorCell
            cell.post = entry
            return cell
        case .taglineCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: TaglineCell.self, for: self, at: index) as! TaglineCell
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

    override func didSelectItem(at index: Int) {
        if heroCellType(rawValue: index) != .actionMenuCell {
            delegate?.articleSectionDidPressOnArticle(entry)
        }
    }
}
