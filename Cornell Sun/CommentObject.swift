//
//  CommentObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 10/5/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Realm

class CommentObject: Object {
    private let wpDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"    // "2016-01-29T01:45:33"
        return formatter
    }()

    @objc dynamic var id: Int = 0
    @objc dynamic var authorName: String = ""
    @objc dynamic var comment: String = ""
    @objc dynamic var date: Date = Date()
    var profileImageURL: URL?
    init(id: Int, authorName: String, comment: String, date: Date, imageURL: URL?) {
        super.init()
        self.id = id
        self.authorName = authorName
        self.comment = comment
        self.date = date
        self.profileImageURL = imageURL
    }

    init(id: Int, authorName: String, comment: String, date: Date) {
        super.init()
        self.id = id
        self.authorName = authorName
        self.comment = comment
        self.date = date
        self.profileImageURL = nil

    }

    init?(data: [String: AnyObject]) {
        super.init()
        guard
            let id = data["id"] as? Int,
            let authorMeta = data["from"] as? [String: AnyObject],
            let authorName = authorMeta["name"] as? String,
            let comment = data["message"] as? String,
            let dateMeta = data["created_time"] as? [String: AnyObject],
            let dateString = dateMeta["date"] as? String,
            let date = wpDateFormatter.date(from: dateString)
            else {
                return nil
        }
        self.id = id
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
