//
//  CommentObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import UIKit

class CommentObject: NSObject {
    private let wpDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+00")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"    // 2018-03-07 05:30:35.000000
        return formatter
    }()

    var id: String = ""
    var authorName: String = ""
    var comment: String = ""
    var date: Date = Date()
    var profileImageURL: URL?
    init(id: String, authorName: String, comment: String, date: Date, imageURL: URL?) {
        super.init()
        self.id = id
        self.authorName = authorName
        self.comment = comment
        self.date = date
        self.profileImageURL = imageURL
    }

    init(id: String, authorName: String, comment: String, date: Date) {
        super.init()
        self.id = id
        self.authorName = authorName
        self.comment = comment
        self.date = date
        self.profileImageURL = nil

    }

    init?(data: [String: AnyObject]) {
        guard
            let id = data["id"] as? String,
            let comment = data["message"] as? String,
            let dateMeta = data["created_time"] as? [String: Any],
            let dateString = dateMeta["date"] as? String,
            let date = wpDateFormatter.date(from: dateString),
            let authorMeta = data["from"] as? [String: Any],
            let authorName = authorMeta["name"] as? String,
            let profileImageDict = authorMeta["profile_picture"] as? [String: Any]
            else {
                return nil
        }
        self.id = id
        self.authorName = authorName
        self.comment = comment
        self.date = date
        if let profileURL = profileImageDict["url"] as? String {
            self.profileImageURL = URL(string: profileURL)
        }
    }
}
