//
//  PhotoGalleryObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class PostAttachmentObject: Codable {
    var id: Int?
    var name: String?
    var caption: String?
    var authorName: String?
    var mediaType: String?
    var url: URL!

    enum CodingKeys: String, CodingKey {
        case id, name, caption, url
        case authorName = "author_name"
        case mediaType = "media_type"
    }

}
