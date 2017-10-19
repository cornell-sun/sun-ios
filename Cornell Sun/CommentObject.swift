//
//  CommentObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation

class CommentObject: NSObject {
    private let wpDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss"     // "2016-01-29T01:45:33"
        return formatter
    }()

    var id: Int
    var postId: Int
    var authorName: String
    var comment: String
    var date: Date

    init(id: Int, postId: Int, authorName: String, comment: String, date: Date) {
        self.id = id
        self.postId = postId
        self.authorName = authorName
        self.comment = comment
        self.date = date
    }

    init?(data: [String: AnyObject]) {
        guard
            let id = data["id"] as? Int,
            let postId = data["post"] as? Int,
            let authorName = data["author_name"] as? String,
            let content = data["content"] as? [String: AnyObject],
            let comment = content["rendered"] as? String,
            let dateString = data["date"] as? String,
            let date = wpDateFormatter.date(from: dateString)
            else {
                return nil
        }
        self.id = id
        self.postId = postId
        self.authorName = authorName
        self.comment = comment
        self.date = date

    }
}
