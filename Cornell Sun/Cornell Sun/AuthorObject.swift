//
//  AuthorObject.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import Mapper
import Realm
import RealmSwift

class AuthorObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var link: String = ""
    @objc dynamic var bio: String = ""
    @objc dynamic var avatarLink: String = ""


    init(id: Int, name: String, link: String, bio: String, avatarLink: String) {
        super.init()
        self.id = id
        self.name = name
        self.link = link
        self.bio = bio
        self.avatarLink = avatarLink
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
