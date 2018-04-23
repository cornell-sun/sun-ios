//
//  Delegate+.swift
//  Cornell Sun
//
//  Created by Theodore Carrel on 3/24/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

func pressedShare(entry: PostObject) {
    taptic(style: .light)
    if let articleLink = URL(string: entry.link) {
        let title = entry.title
        let objectToShare = [title, articleLink] as [Any]
        let activityVC = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
        getCurrentViewController()?.present(activityVC, animated: true, completion: nil)
    }
}

func pressedBookmark(_ cell: MenuActionCell, entry: PostObject) {
    let didBookmark = cell.bookmarkButton.currentImage == #imageLiteral(resourceName: "bookmark") //we should save the bookmark
    let correctBookmarkImage = cell.bookmarkButton.currentImage == #imageLiteral(resourceName: "bookmarkPressed") ? #imageLiteral(resourceName: "bookmark") : #imageLiteral(resourceName: "bookmarkPressed")
    cell.bookmarkButton.setImage(correctBookmarkImage, for: .normal)
    cell.bookmarkButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    taptic(style: .light)
    UIView.animate(withDuration: 1.0,
                   delay: 0,
                   usingSpringWithDamping: CGFloat(0.4),
                   initialSpringVelocity: CGFloat(6.0),
                   options: UIViewAnimationOptions.allowUserInteraction,
                   animations: {
                    cell.bookmarkButton.transform = CGAffineTransform.identity
    })
    if didBookmark {
        PostOffice.instance.store(object: entry)
    } else {
        PostOffice.instance.remove(object: entry)
    }
}
