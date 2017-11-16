//
//  CommentObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class CommentObject: Object {
    private let wpDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss"     // "2016-01-29T01:45:33"
        return formatter
    }()

    @objc dynamic var id: Int = 0
    @objc dynamic var postId: Int = 0
    @objc dynamic var authorName: String = ""
    @objc dynamic var comment: String = ""
    @objc dynamic var date: Date = Date()

    init(id: Int, postId: Int, authorName: String, comment: String, date: Date) {
        super.init()
        self.id = id
        self.postId = postId
        self.authorName = authorName
        self.comment = comment
        self.date = date
    }

    init?(data: [String: AnyObject]) {
        super.init()
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

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init() {
        super.init()
    }

}
