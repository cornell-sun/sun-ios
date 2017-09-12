//
//  PostObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class PostObject: NSObject {
    var id: Int
    var datePosted: Date
    var link: String
    var title: String
    var content: String
    var excerpt: String
    var author: AuthorObject
    var categories: [Int]
    var tags: [Int]
    var mediaLink: String

    init(id: Int, datePosted: Date, link: String, title: String, content: String, excerpt: String, author: AuthorObject, categories: [Int], tags: [Int], mediaLink: String) {
        self.id = id
        self.datePosted = datePosted
        self.link = link
        self.title = title
        self.content = content
        self.excerpt = excerpt
        self.author = author
        self.categories = categories
        self.tags = tags
        self.mediaLink = mediaLink
    }

}
