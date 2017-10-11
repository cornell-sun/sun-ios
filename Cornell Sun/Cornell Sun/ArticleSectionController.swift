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

class ArticleSectionController: ListSectionController {
    var entry: PostObject!

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension ArticleSectionController {

    override func numberOfItems() -> Int {
        return 5
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        switch index {
        case 0:
            return CGSize(width: width, height: 40)
        case 1:
            let height = entry.title.height(withConstrainedWidth: width, font: UIFont.boldSystemFont(ofSize: 22)) //CLUTCH Extension thank stackoverflow gods
            return CGSize(width: width, height: height + 10)
        case 2:
            return CGSize(width: width, height: width / 1.92)
        case 3:
            return CGSize(width: width, height: 25)
            //return entry.comments.isEmpty ? .zero : CGSize(width: width, height: 25)
        case 4:
            return CGSize(width: width, height: 35)
        default:
            return .zero
        }
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        switch index {
        case 0:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: CategoryCell.self, for: self, at: index) as! CategoryCell
            cell.post = entry
            return cell
        case 1:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: TitleCell.self, for: self, at: index) as! TitleCell
            cell.post = entry
            return cell
        case 2:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as! ImageCell
            cell.post = entry
            return cell
        case 3:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: LikeCommentCell.self, for: self, at: index) as! LikeCommentCell
            cell.post = entry
            return cell
        case 4:
            // swiftlint:disable:next force_cast
            let cell = collectionContext!.dequeueReusableCell(of: MenuActionCell.self, for: self, at: index)
            return cell
        default:
            return UICollectionViewCell()
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
        if let postUrl = URL(string: entry.link),
            let currentVC = getCurrentViewController() {
            let sfVC = SFSafariViewController(url: postUrl, entersReaderIfAvailable: true)
            currentVC.present(sfVC, animated: true)

        }
    }
}
