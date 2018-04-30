//
//  PostObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import IGListKit
import HTMLString
import Kingfisher

class PostObject: NSObject, Codable, ListDiffable {

    //Bookmark data
    var storeDate: Date?
    var didSave = false

    //Post data
    var id: Int!
    var date: Date!
    var title: String!
    var content: String!
    var excerpt: String!
    var link: URL!
    var author: [AuthorObject]!
    var featuredMediaImages: FeaturedMediaImages!
    var featuredMediaCaption: String?
    var featuredMediaCredit: String?
    var categories: [String]!
    var primaryCategory: String!
    var tags: [String]!
    var postAttachments: [PostAttachmentObject]!
    var postType: PostType!

    required init(from decoder: Decoder) throws {

        var nested: KeyedDecodingContainer<PostObject.PostInfoCodingKeys>!
        if
            let container = try? decoder.container(keyedBy: CodingKeyInfo.self),
            let nestedContainer = try? container.nestedContainer(keyedBy: PostInfoCodingKeys.self, forKey: .postInfoDict) {
            nested = nestedContainer
        } else {
            nested = try decoder.container(keyedBy: PostInfoCodingKeys.self)
        }

        self.id = try nested.decode(Int.self, forKey: .id)
        self.date = try nested.decode(Date.self, forKey: .date)
        self.title = try nested.decode(String.self, forKey: .title)
        self.excerpt = try nested.decode(String.self, forKey: .excerpt)
        self.link = try nested.decode(URL.self, forKey: .link)
        self.content = try nested.decode(String.self, forKey: .content)
        self.author = try nested.decode([AuthorObject].self, forKey: .author)
        self.featuredMediaImages = try nested.decode(FeaturedMediaImages.self, forKey: .featuredMediaImages)
        self.featuredMediaCaption = try nested.decode(String?.self, forKey: .featuredMediaCaption)
        self.featuredMediaCredit = try nested.decode(String?.self, forKey: .featuredMediaCredit)
        self.categories = try nested.decode([String].self, forKey: .categories)
        self.primaryCategory = try nested.decode(String.self, forKey: .primaryCategory)
        self.tags = try nested.decode([String].self, forKey: .tags)
        self.postType = try nested.decode(PostType.self, forKey: .postType)
        self.postAttachments = try nested.decode([PostAttachmentObject].self, forKey: .postAttachments)
        self.didSave = (try? nested.decode(Bool.self, forKey: .didSave)) ?? false
        self.storeDate = try? nested.decode(Date.self, forKey: .storeDate)

        //cache image
        if let mediumImageURL = self.featuredMediaImages.mediumLarge?.url {
            cacheImage(imageURL: mediumImageURL)
        }
        super.init()
    }
}

extension PostObject {

    enum CodingKeyInfo: String, CodingKey {
        case postInfoDict = "post_info_dict"
    }

    enum PostInfoCodingKeys: String, CodingKey {
        case id, date, title, excerpt, link, didSave, storeDate
        case content = "post_content_no_srcset"
        case author = "author_dict"
        case featuredMediaImages = "featured_media_url_string"
        case featuredMediaCaption = "featured_media_caption"
        case featuredMediaCredit = "featured_media_credit"
        case categories = "category_strings"
        case primaryCategory = "primary_category"
        case tags = "tag_strings"
        case postType = "post_type_enum"
        case postAttachments = "post_attachments_meta"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PostInfoCodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(title, forKey: .title)
        try container.encode(excerpt, forKey: .excerpt)
        try container.encode(link, forKey: .link)
        try container.encode(content, forKey: .content)
        try container.encode(author, forKey: .author)
        try container.encode(featuredMediaImages, forKey: .featuredMediaImages)
        try container.encode(featuredMediaCaption, forKey: .featuredMediaCaption)
        try container.encode(featuredMediaCredit, forKey: .featuredMediaCredit)
        try container.encode(categories, forKey: .categories)
        try container.encode(primaryCategory, forKey: .primaryCategory)
        try container.encode(tags, forKey: .tags)
        try container.encode(postType, forKey: .postType)
        try container.encode(postAttachments, forKey: .postAttachments)
        try container.encode(didSave, forKey: .didSave)
        try container.encode(storeDate, forKey: .storeDate)
    }

    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        //guard self !== object else { return true }
        guard let object = object as? PostObject else { return false }
        return self.id == object.id && self.didSave == object.didSave
    }
}
