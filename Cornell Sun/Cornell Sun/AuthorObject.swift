//
//  AuthorObject.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import UIKit

class AuthorObject: NSObject {
    var id: Int
    var name: String
    var link: String
    var bio: String
    var avatarLink: String

    init(id: Int, name: String, link: String, bio: String, avatarLink: String) {
        self.id = id
        self.name = name
        self.link = link
        self.bio = bio
        self.avatarLink = avatarLink
    }
}
