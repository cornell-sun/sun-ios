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
        let correctBookmarkImage = cell.bookmarkButton.currentImage == #imageLiteral(resourceName: "bookmarkPressed") ? #imageLiteral(resourceName: "bookmark") : #imageLiteral(resourceName: "bookmarkPressed")
        cell.bookmarkButton.setImage(correctBookmarkImage, for: .normal)
        cell.bookmarkButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        taptic(style: .light)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.40),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        cell.bookmarkButton.transform = CGAffineTransform.identity
        })
    }

    func didPressShare() {
        taptic(style: .light)
        if let articleLink = URL(string: entry.link) {
            let title = entry.title
            let objectToShare = [title, articleLink] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            getCurrentViewController()?.present(activityVC, animated: true, completion: nil)
        }
    }

    override func numberOfItems() -> Int {
        return 5
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
            return CGSize(width: width, height: height + 10)
        case .authorCell:
            guard let height = entry.author?.name.height(withConstrainedWidth: width, font: .articleSection) else { return .zero}
            return CGSize(width: width, height: height)
        case .taglineCell:
            let lineHeight: CGFloat = UIFont.articleSection.lineHeight * 4.0
            let height = entry.excerpt.removingHTMLEntities.height(withConstrainedWidth: width, font: .articleSection)
            let correctHeight = lineHeight <= height ? lineHeight : height
            return CGSize(width: width, height: correctHeight)
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
