//
//  CommentObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import UIKit

class CommentObject: Codable {

//    private let wpDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"    // "2016-01-29T01:45:33"
//        return formatter
//    }()

    var id: Int
    var authorName: String
    var comment: String
    var date: Date
    var profileImageURL: URL?

    init(id: Int, authorName: String, comment: String, date: Date, imageURL: URL?) {
        self.id = id
        self.authorName = authorName
        self.comment = comment
        self.date = date
        self.profileImageURL = imageURL
    }

    init?(data: [String: AnyObject]) {
        guard
            let id = data["id"] as? Int,
            let authorMeta = data["from"] as? [String: AnyObject],
            let authorName = authorMeta["name"] as? String,
            let comment = data["message"] as? String,
            let dateMeta = data["created_time"] as? [String: AnyObject],
            let date = dateMeta["date"] as? Date
            else {
                return nil
        }
        self.id = id
        self.authorName = authorName
        self.comment = comment
        self.date = date

    }
}
