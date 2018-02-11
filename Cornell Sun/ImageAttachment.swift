//
//  ImageAttachment.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 2/10/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import UIKit

class ImageAttachment: NSTextAttachment {

    var verticalOffset: CGFloat = 0

    convenience init(_ image: UIImage, verticalOffset: CGFloat = 0) {
        self.init()
        self.image = image
        self.verticalOffset = verticalOffset
    }

    override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        guard let imageSize = image?.size else { return .zero }

        return CGRect(x: (UIScreen.main.bounds.width - imageSize.width) / 2, y: 0, width: imageSize.width, height: imageSize.height)
    }
}
