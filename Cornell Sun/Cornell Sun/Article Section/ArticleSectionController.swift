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
    case likeCommentCell = 4
    case actionMenuCell = 5
}

class ArticleSectionController: ListSectionController {
    var entry: PostObject!
    weak var delegate: TabBarViewControllerDelegate?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension ArticleSectionController: HeartPressedDelegate, BookmarkPressedDelegate, SharePressedDelegate {

    func didPressBookmark(_ cell: MenuActionCell) {
        let didBookmark = cell.bookmarkButton.currentImage == #imageLiteral(resourceName: "bookmark") //we should save the bookmark
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
        if didBookmark {
            RealmManager.instance.save(object: entry)
        } else {
            RealmManager.instance.delete(object: entry)
        }
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
        taptic(style: .light)
        if let articleLink = URL(string: entry.link) {
            let title = entry.title
            let objectToShare = [title, articleLink] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
            getCurrentViewController()?.present(activityVC, animated: true, completion: nil)
        }
    }

    override func numberOfItems() -> Int {
        return 6
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        guard let sizeForItemIndex = cellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .categoryCell:
            return CGSize(width: width, height: 40)
        case .titleCell:
            let height = entry.title.height(withConstrainedWidth: width - 34, font: UIFont.boldSystemFont(ofSize: 22)) //CLUTCH Extension thank stackoverflow gods
            return CGSize(width: width, height: height + 10)
        case .authorCell:
            let height = entry.author?.name.height(withConstrainedWidth: width, font: UIFont(name: "Georgia", size: 13)!)
            return CGSize(width: width, height: height! + 9)
        case .imageCell:
            return CGSize(width: width, height: width / 1.92)
        case .likeCommentCell:
            let hasComments = !entry.comments.isEmpty
            return hasComments ? CGSize(width: width, height: 25) : .zero
        case .actionMenuCell:
            return CGSize(width: width, height: 35)
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
        case .likeCommentCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: LikeCommentCell.self, for: self, at: index) as! LikeCommentCell
            cell.post = entry
            return cell
        case .actionMenuCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: MenuActionCell.self, for: self, at: index) as! MenuActionCell
            cell.heartDelegate = self
            cell.bookmarkDelegate = self
            cell.shareDelegate = self
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
        if index != 5 {
            delegate?.articleSectionDidPressOnArticle(entry)
        }
    }
}
