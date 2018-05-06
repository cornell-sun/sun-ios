//
//  SuggestedStoryObject.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 5/4/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

class SuggestedStoryObject: Codable {
    var postID: Int!
    var title: String!
    var authors: [AuthorObject]?
    var featuredMediaImages: FeaturedMediaImages!

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        postID = try container.decode(Int.self, forKey: .postID)
        title = try container.decode(String.self, forKey: .title)
        authors = try? container.decode([AuthorObject].self, forKey: .authorName)

        featuredMediaImages = try container.decode(FeaturedMediaImages.self, forKey: .featuredMediaImages)

        if let mediumImageURL = featuredMediaImages.mediumLarge?.url {
            cacheImage(imageURL: mediumImageURL)
        }

    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(postID, forKey: .postID)
        try container.encode(title, forKey: .title)
        try container.encode(authors, forKey: .authorName)
        try container.encode(featuredMediaImages, forKey: .featuredMediaImages)
    }

    enum CodingKeys: String, CodingKey {
        case postID = "post_id"
        case title = "title"
        case authorName = "author_dict"
        case featuredMediaImages = "featured_media"
    }

}
