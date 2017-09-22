//
//  ArticleSectionController.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 9/3/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import IGListKit

class ArticleSectionController: ListSectionController {
    var entry: PostObject!

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension ArticleSectionController {
    override func numberOfItems() -> Int {
        return 1
    }

    override func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext, entry != nil else {return .zero}
        let width = context.containerSize.width
        
        return CGSize(width: width, height: 300)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        // swiftlint:disable:next force_cast
        let cell = collectionContext!.dequeueReusableCell(of: ArticleCell.self, for: self, at: index) as! ArticleCell
        cell.backgroundColor = .lightGray
        cell.post = entry

        return cell
    }

    override func didUpdate(to object: Any) {
        entry = object as? PostObject
    }

    override func didSelectItem(at index: Int) {

    }
}
