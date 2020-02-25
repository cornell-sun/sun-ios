//
//  ArticleSectionController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/3/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import SafariServices

protocol TabBarViewControllerDelegate: class {
    func articleSectionDidPressOnArticle(_ article: PostObject)
}

// swiftlint:disable:next type_name
enum cellType: Int {
    case categoryCell = 0
    case titleCell = 1
    case authorCell = 2
    case imageCell = 3
    case actionMenuCell = 4
}

class ArticleSectionController: ListSectionController {
    var entry: PostObject!
    weak var delegate: TabBarViewControllerDelegate?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension ArticleSectionController: BookmarkPressedDelegate, SharePressedDelegate {

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
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        guard let sizeForItemIndex = cellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .categoryCell:
            return CGSize(width: width, height: 45)
        case .titleCell:
            //106.0 is the height needed for 4 lines of text
            var height = entry.title.height(withConstrainedWidth: width - 34, font: .articleTitle, lineSpacing: 4.5) //CLUTCH Extension thank stackoverflow gods
            height = height <= 106.0 ? height : 106.0
            return CGSize(width: width, height: height + 20)
        case .authorCell:
            let height = entry.author?.byline.height(withConstrainedWidth: width, font: .cellInformationText) ?? 0
            return CGSize(width: width, height: height + 13)
        case .imageCell:
            if entry.featuredMediaImages?.mediumLarge?.url == nil {
                return .zero
            } else {
                return CGSize(width: width, height: width / 1.92)
            }
        case .actionMenuCell:
            return CGSize(width: width, height: 50)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cellForItemIndex = cellType(rawValue: index) else {
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
        case .authorCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: AuthorCell.self, for: self, at: index) as! AuthorCell
            cell.post = entry
            return cell
        case .imageCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as! ImageCell
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

    func getCurrentViewController() -> UIViewController? {

        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while currentController.presentedViewController != nil {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil

    }

    override func didSelectItem(at index: Int) {
        if cellType(rawValue: index) != .actionMenuCell {
            delegate?.articleSectionDidPressOnArticle(entry)
        }
    }
}
