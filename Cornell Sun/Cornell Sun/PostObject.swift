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
    var author: Int
    var categories: [Int]
    var tags: [Int]
    var authorObject: Int //Replace Int with object mindy creates
    var mediaLink: String
    
    init(id: Int, datePosted: Date, link: String, title: String, content: String, excerpt: String, author: Int, categories: [Int], tags: [Int], authorObject: Int, mediaLink: String) {
        self.id = id
        self.datePosted = datePosted
        self.link = link
        self.title = title
        self.content = content
        self.excerpt = excerpt
        self.author = author
        self.categories = categories
        self.tags = tags
        self.authorObject = authorObject
        self.mediaLink = mediaLink
    }
    
    
    
}
