//
//  PhotoGalleryObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 11/14/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit

class PhotoGalleryObject: Codable {
    var id: Int
    var caption: String
    var authorName: String
    var fullImageLink: String

    init(id: Int, caption: String, authorName: String, fullImageLink: String) {
        self.id = id
        self.caption = caption
        self.authorName = authorName
        self.fullImageLink = fullImageLink
    }

//    init? (data: [String: Any]) {
//        super.init()
//        guard
//        let id = data["id"] as? Int,
//        let caption = data["caption"] as? String,
//        let authorName = data["author_name"] as? String,
//        let fullImageLink = data["full"] as? String
//        else { return nil }
//
//        self.id = id
//        self.caption = caption
//        self.authorName = authorName
//        self.fullImageLink = fullImageLink
//
//        DispatchQueue.main.async {
//            cacheImage(imageLink: fullImageLink)
//        }
//    }
}
