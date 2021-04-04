//
//  String+.swift
//  Cornell Sun
//
//  Created by Cameron Hamidi on 3/19/21.
//  Copyright © 2021 cornell.sun. All rights reserved.
//

import Foundation
import UIKit

extension String {

//    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.text = self
//        label.font = font
//        label.sizeToFit()
//
//        return label.frame.height
//    }

    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }

}
