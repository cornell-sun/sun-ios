//
//  Enums.swift
//  Cornell Sun
//
//  Created by Aditya Dwivedi on 10/27/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import UIKit

enum SettingType {
    case clickable, unclickable
}
enum SecondaryViewType {
    case none, label, toggle //Can add more if needed
}

enum FontSize {
    case regular
    case large
    case small

    func getFont() -> UIFont {
        switch self {
        case .regular:
            return .articleBody
        case .large:
            return .articleBodyLarge
        case .small:
            return .articleBodySmall
        }
    }
}

enum ArticleContentType {
    case text(NSAttributedString)
    case image(String)
    case imageCredit(String)
    case caption(String)
    case blockquote(String)
}
