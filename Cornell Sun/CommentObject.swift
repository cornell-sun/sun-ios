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
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"    // "2016-01-29T01:45:33"
        return formatter
    }()

    var id: Int
    var postId: Int
    var authorName: String
    var comment: String
    var date: Date
    var profileImage: UIImage?

    init(id: Int, postId: Int, authorName: String, comment: String, date: Date, image: UIImage) {
        self.id = id
        self.postId = postId
        self.authorName = authorName
        self.comment = comment
        self.date = date
        self.profileImage = image
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
        self.profileImage = #imageLiteral(resourceName: "emptyProfile") // default egg for now

    }
}
