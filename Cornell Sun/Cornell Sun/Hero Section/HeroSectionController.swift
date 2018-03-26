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
    case taglineCell = 2
    case actionMenuCell = 3
}

class HeroSectionController: ListSectionController {
    var entry: PostObject!

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension HeroSectionController: HeartPressedDelegate, BookmarkPressedDelegate, SharePressedDelegate {

    func didPressBookmark(_ cell: MenuActionCell) {
        pressedBookmark(cell, entry: entry)
    }

    func didPressHeart(_ cell: MenuActionCell) {
        let correctHeartImage = cell.heartButton.currentImage == #imageLiteral(resourceName: "heartPressed") ? #imageLiteral(resourceName: "heart") : #imageLiteral(resourceName: "heartPressed")
        cell.heartButton.setImage(correctHeartImage, for: .normal)
        cell.heartButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        taptic(style: .light)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.40),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        cell.heartButton.transform = CGAffineTransform.identity
        })
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
        guard let sizeForItemIndex = heroCellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .imageCell:
            return CGSize(width: width, height: width / 1.5)
        case .titleCell:
            let height = entry.title.height(withConstrainedWidth: width, font: UIFont.boldSystemFont(ofSize: 22)) //CLUTCH Extension thank stackoverflow gods
            return CGSize(width: width, height: height + 5)
        case .taglineCell:
            return CGSize(width: width, height: 26)
        case .actionMenuCell:
            return CGSize(width: width, height: 35)
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
        case .taglineCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: TaglineCell.self, for: self, at: index) as! TaglineCell
            cell.post = entry
            return cell
        case .actionMenuCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: MenuActionCell.self, for: self, at: index) as! MenuActionCell
            cell.heartDelegate = self
            cell.bookmarkDelegate = self
            cell.shareDelegate = self
            cell.setupViews(forBookmarks: false)
            return cell
        }
    }

    override func didUpdate(to object: Any) {
        entry = object as? PostObject
    }

    override func didSelectItem(at index: Int) {
        if index == 0 {

        }
    }
}
