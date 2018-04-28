//
//  PostObjectHelpers.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/24/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import Foundation

class FeaturedMediaImages: Codable {
    var mediumLarge: ImageInfo?
    var thumbnail: ImageInfo?
    var full: ImageInfo?

    init(mediumLarge: ImageInfo?, thumbnail: ImageInfo?, full: ImageInfo?) {
        self.mediumLarge = mediumLarge
        self.thumbnail = thumbnail
        self.full = full
    }

    enum CodingKeys: String, CodingKey {
        case thumbnail, full
        case mediumLarge = "medium_large"
    }
}

class ImageInfo: Codable {
    var url: URL?
    var width: Int?
    var height: Int?

    init(url: URL?, width: Int?, height: Int?) {
        self.url = url
        self.width = width
        self.height = height
    }
}
