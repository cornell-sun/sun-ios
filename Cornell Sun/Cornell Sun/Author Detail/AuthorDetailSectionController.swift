//
//  AuthorDetailSectionController.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/10/19.
//  Copyright © 2019 cornell.sun. All rights reserved.
//

import IGListKit
import Foundation

class AuthorDetailSectionController: ListSectionController {
    
    var authorDetailObject: AuthorDetailObject!
    var screenWidth: CGFloat!

    convenience init(authorDetail: AuthorDetailObject, screenWidth: CGFloat) {
        self.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        self.authorDetailObject = authorDetail
        self.screenWidth = screenWidth
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext?.containerSize else { return .zero }
        let height = AuthorDetailCell.getHeight(for: authorDetailObject, screenWidth: screenWidth)
        return CGSize(width: context.width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        let cell = collectionContext?.dequeueReusableCell(of: AuthorDetailCell.self, for: self, at: index) as! AuthorDetailCell
        cell.configure(for: authorDetailObject)
        return cell
    }

    override func didUpdate(to object: Any) {
        authorDetailObject = object as? AuthorDetailObject
    }
}
