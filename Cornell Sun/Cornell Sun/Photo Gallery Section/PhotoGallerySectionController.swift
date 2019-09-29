//
//  PhotoGallerySectionController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit
//import ImageSlideshow

// swiftlint:disable:next type_name
enum photoGalleryCellType: Int {
    case categoryCell = 0
    case titleCell = 1
    case authorCell = 2
    case photoGalleryCell = 3
    case captionCell = 4
    case actionMenuCell = 5
}

class PhotoGallerySectionController: ListSectionController {
    var entry: PostObject!

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension PhotoGallerySectionController: BookmarkPressedDelegate, SharePressedDelegate, PhotoChangedDelegate {

    func didPressBookmark(_ cell: MenuActionCell) {
        pressedBookmark(cell, entry: entry)
    }

    func didPressShare() {
        pressedShare(entry: entry)
    }

    func photoDidChange(_ index: Int) {
        let captionCell: photoGalleryCellType = .captionCell
        let captionIndex = captionCell.rawValue
        if let cell = collectionContext?.cellForItem(at: captionIndex, sectionController: self) as? CaptionCell {
            cell.updateCaption(index: index)
        }
    }

    override func numberOfItems() -> Int {
        return 6
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        guard let sizeForItemIndex = photoGalleryCellType(rawValue: index) else {
            return .zero
        }
        switch sizeForItemIndex {
        case .categoryCell:
            return CGSize(width: width, height: 45)
        case .titleCell:
            let height = entry.title.height(withConstrainedWidth: width - 34, font: .articleTitle, lineSpacing: 4.5) //CLUTCH Extension thank stackoverflow gods
            return CGSize(width: width, height: height + 20)
        case .authorCell:
            let height = entry.author?.byline.height(withConstrainedWidth: width, font: .photoCaption) ?? 0
            return CGSize(width: width, height: height + 13)
        case .photoGalleryCell:
            return CGSize(width: width, height: width / 1.5)
        case .captionCell:
            let height = captionMaxHeight(width: width)
            return CGSize(width: width, height: height + 16)
        case .actionMenuCell:
            return CGSize(width: width, height: 50)
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
