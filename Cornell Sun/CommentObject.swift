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
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"    // 2018-03-07 05:30:35.000000
        return formatter
    }()

    @objc dynamic var id: String = ""
    @objc dynamic var authorName: String = ""
    @objc dynamic var comment: String = ""
    @objc dynamic var date: Date = Date()
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
        super.init()
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
