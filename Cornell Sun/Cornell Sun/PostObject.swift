//
//  PostObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import Mapper
import IGListKit

class PostObject: Mappable, ListDiffable {
    private let wpDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss"     // "2016-01-29T01:45:33"
        return formatter
    }()

    var id: Int
    var datePosted: Date
    var link: String
    var title: String
    var content: String
    var excerpt: String
    var authorId: Int
    var categories: [Int]
    var tags: [Int]
    var mediaLink: String

    required init(map: Mapper) throws {
        try id = map.from("id")
        datePosted = Date() //@Todo: get the actual date
        try link = map.from("link")
        try title = map.from("title.rendered")
        try content = map.from("content.rendered")
        try excerpt = map.from("excerpt.rendered")
        try authorId = map.from("author")
        try categories = map.from("categories")
        try tags = map.from("tags")
        try mediaLink = map.from("_links.wp:featuredmedia.0.href")
    }

    init? (data: [String: AnyObject], mediaLink: String) {
        guard
        let id = data["id"] as? Int,
        let dateString = data["date"] as? String,
        let date = wpDateFormatter.date(from: dateString),
        let titleDictionary = data["title"] as? [String:Any],
        let title = titleDictionary["rendered"] as? String,
        let contentDictionary = data["content"] as? [String: Any],
        let content = contentDictionary["rendered"] as? String,
        let link = data["link"] as? String
            else {
                return nil
    }
        self.id = id
        self.datePosted = date
        self.title = title
        self.content = content
        self.link = link
        self.excerpt = "excerpt"
        self.authorId = 111
        self.categories = [0]
        self.tags = [1, 2, 3]
        self.mediaLink = mediaLink
    }

    init(id: Int, datePosted: Date, link: String, title: String, content: String, excerpt: String, author: AuthorObject, categories: [Int], tags: [Int], mediaLink: String) {
        self.id = id
        self.datePosted = datePosted
        self.link = link
        self.title = title
        self.content = content
        self.excerpt = excerpt
        self.authorId = 99999
        self.categories = categories
        self.tags = tags
        self.mediaLink = mediaLink
    }

    func diffIdentifier() -> NSObjectProtocol {
        return title as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true } else {
            return false
        }
    }

}
