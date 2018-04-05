//
//  UIColor+1ptImage.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 4/2/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
    ///
    /// - Returns: `self` as a 1x1 `UIImage`.
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 0.5, height: 0.5))
        self.setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
