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

    convenience init(authorDetail: AuthorDetailObject) {
        self.init()
        self.authorDetailObject = authorDetail
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext?.containerSize else { return .zero }
        return CGSize(width: context.width, height: 265)
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
