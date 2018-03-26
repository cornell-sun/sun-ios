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

enum ArticleContentType {
    case text(NSAttributedString)
    case image(String)
    case imageCredit(String)
    case caption(String)
}
