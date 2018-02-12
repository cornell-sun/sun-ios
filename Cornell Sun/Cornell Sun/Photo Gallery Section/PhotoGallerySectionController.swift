//
//  PhotoGallerySectionController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
import ImageSlideshow

// swiftlint:disable:next type_name
enum photoGalleryCellType: Int {
    case categoryCell = 0
    case titleCell = 1
    case authorCell = 2
    case photoGalleryCell = 3
    case captionCell = 4
    case likeCommentCell = 5
    case actionMenuCell = 6
}

class PhotoGallerySectionController: ListSectionController {
    var entry: PostObject!

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension PhotoGallerySectionController: HeartPressedDelegate, BookmarkPressedDelegate, SharePressedDelegate, PhotoChangedDelegate {

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

    func photoDidChange(_ index: Int) {
        let captionCell: photoGalleryCellType = .captionCell
        let captionIndex = captionCell.rawValue
        if let cell = collectionContext?.cellForItem(at: captionIndex, sectionController: self) as? CaptionCell {
            cell.updateCaption(index: index)
        }
    }

    override func numberOfItems() -> Int {
        return 7
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        guard let sizeForItemIndex = photoGalleryCellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .categoryCell:
            return CGSize(width: width, height: 40)
        case .titleCell:
            let height = entry.title.height(withConstrainedWidth: width, font: UIFont.boldSystemFont(ofSize: 22)) //CLUTCH Extension thank stackoverflow gods
            return CGSize(width: width, height: height + 5)
        case .authorCell:
            let height = entry.author?.name.height(withConstrainedWidth: width, font: UIFont(name: "Georgia", size: 13)!)
            return CGSize(width: width, height: height! + 9)
        case .photoGalleryCell:
            return CGSize(width: width, height: width / 1.5)
        case .captionCell:
            let height = captionMaxHeight(width: width)

            return CGSize(width: width, height: height + 16)
        case .likeCommentCell:
            let hasComments = !entry.comments.isEmpty
            return hasComments ? CGSize(width: width, height: 25) : .zero
        case .actionMenuCell:
            return CGSize(width: width, height: 35)
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cellForItemIndex = photoGalleryCellType(rawValue: index) else {
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
        case .photoGalleryCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: PhotoGalleryCell.self, for: self, at: index) as! PhotoGalleryCell
            cell.photoGalleryDelegate = self
            cell.post = entry
            return cell
        case .captionCell:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: CaptionCell.self, for: self, at: index) as! CaptionCell
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
}
