//
//  PhotoGalleryObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class PhotoGalleryObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var caption: String = ""
    @objc dynamic var authorName: String = ""
    @objc dynamic var fullImageLink: String = ""

    init(id: Int, caption: String, authorName: String, fullImageLink: String) {
        super.init()
        self.id = id
        self.caption = caption
        self.authorName = authorName
        self.fullImageLink = fullImageLink
    }

    init? (data: [String: Any]) {
        super.init()
        guard
        let id = data["id"] as? Int,
        let caption = data["caption"] as? String,
        let authorName = data["author_name"] as? String,
        let fullImageLink = data["full"] as? String
        else { return nil }

        self.id = id
        self.caption = caption
        self.authorName = authorName
        self.fullImageLink = fullImageLink

        cacheImage(imageLink: fullImageLink)
    }

    required init() {
        super.init()
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }


}
