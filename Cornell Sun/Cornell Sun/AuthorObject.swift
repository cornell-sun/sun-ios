//
//  AuthorObject.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import Mapper

class AuthorObject: Mappable {
    var id: Int
    var name: String
    var link: String
    var bio: String
    var avatarLink: String

    required init(map: Mapper) throws {
        try id = map.from("id")
        try name = map.from("name")
        try link = map.from("link")
        try bio = map.from("description")
        try avatarLink = map.from("avatar_urls.96")
    }

    init(id: Int, name: String, link: String, bio: String, avatarLink: String) {
        self.id = id
        self.name = name
        self.link = link
        self.bio = bio
        self.avatarLink = avatarLink
    }

}
