//
//  AuthorObject.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import UIKit
import TRON
import SwiftyJSON

class AuthorObject: NSObject, JSONDecodable {
    var id: Int = 0
    var name: String = ""
    var link: String = ""
    var bio: String = ""
    var avatarLink: String = ""
    

    required init(json: JSON) throws {
        super.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.link = json["link"].stringValue
        self.bio = json["description"].stringValue
        self.avatarLink = json["avatar_urls"]["96"].stringValue
    }
    
    init(id: Int, name: String, link: String, bio: String, avatarLink: String) {
        self.id = id
        self.name = name
        self.link = link
        self.bio = bio
        self.avatarLink = avatarLink
    }
    
}
