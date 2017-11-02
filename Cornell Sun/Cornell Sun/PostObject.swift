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
import HTMLString
import Kingfisher

class PostObject: ListDiffable {
    private let wpDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"     // "2016-01-29T01:45:33"
        return formatter
    }()

    var id: Int
    var datePosted: Date
    var link: String
    var title: String
    var content: String
    var excerpt: String
    var authorId: Int
    var categories: Int
    var tags: [Int]
    var mediaLink: String
    var comments: [CommentObject]

    init? (data: [String: AnyObject], mediaLink: String, comments: [CommentObject]) {
        guard
        let id = data["id"] as? Int,
        let dateString = data["date"] as? String,
        let date = wpDateFormatter.date(from: dateString),
        let titleDictionary = data["title"] as? [String:Any],
        let title = titleDictionary["rendered"] as? String,
        let contentDictionary = data["content"] as? [String: Any],
        let content = contentDictionary["rendered"] as? String,
        let link = data["link"] as? String,
        let categories = data["categories"] as? [Int],
        let author = data["author"] as? Int
            else {
                return nil
    }
        let smallestCategoryNumber = categories.filter { (category) -> Bool in
            return category > 1
        }.min() ?? 1
        self.id = id
        self.datePosted = date
        self.title = title.removingHTMLEntities
        self.content = content.htmlToString
        self.link = link
        self.excerpt = "excerpt"
        self.authorId = author
        self.categories = smallestCategoryNumber
        self.tags = [1, 2, 3]
        self.mediaLink = mediaLink
        self.comments = comments
        cacheImage(imageLink: mediaLink)
    }

    init(id: Int, datePosted: Date, link: String, title: String, content: String, excerpt: String, author: AuthorObject, categories: [Int], tags: [Int], mediaLink: String, comments: [CommentObject]) {
        self.id = id
        self.datePosted = datePosted
        self.link = link
        self.title = title
        self.content = content
        self.excerpt = excerpt
        self.authorId = 99999
        self.categories = categories.min()!
        self.tags = tags
        self.mediaLink = mediaLink
        self.comments = comments
    }

    func cacheImage(imageLink: String) {
        if let urlImage = URL(string: imageLink) {
            KingfisherManager.shared.retrieveImage(with: urlImage, options: nil, progressBlock: nil, completionHandler: nil)
        }
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
