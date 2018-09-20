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
    case nonSetting, contactus, feedback, history, appteam, masthead, rate, privacy
}

enum ArticleContentType {
    case text(NSAttributedString)
    case image(String)
    case imageCredit(String)
    case caption(String)
    case blockquote(String)
    case heading(String)
}

enum PostType: String, Codable {
    case article
    case photoGallery
    case video
}
