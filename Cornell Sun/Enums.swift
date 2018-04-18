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
    case none, contactus, feedback, history, appteam, masthead, rate, privacy
}

enum ArticleContentType {
    case text(NSAttributedString)
    case image(String)
    case imageCredit(String)
    case caption(String)
    case blockquote(String)
}
