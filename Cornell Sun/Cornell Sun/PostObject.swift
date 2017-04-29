//
//  PostObject.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import UIKit
import TRON
import SwiftyJSON

class PostObject: NSObject, JSONDecodable {
    var id: Int = 0
    var datePosted: Date = Date()
    var link: String = ""
    var title: String = ""
    var content: String = ""
    var excerpt: String = ""
    var author: AuthorObject? = nil
    var categories: [Int] = [Int]()
    var tags: [Int] = [Int]()
    var mediaLink: String = ""
    
    required init(json: JSON) throws {
        super.init()
        self.id = json["id"].intValue
        self.datePosted = Date()
        self.link = json["link"].stringValue
        self.title = json["title"]["rendered"].stringValue
        self.content = json["content"]["rendered"].stringValue
        self.excerpt = json["excerpt"]["rendered"].stringValue
        let authorID = json["author"].intValue
        Network.getAuthor(id: authorID).perform(withSuccess: { author in
            self.author = author
        })
        self.categories = json["categories"].arrayObject as! [Int]
        self.tags = json["tags"].arrayObject as! [Int]
        self.mediaLink = json["_links"]["wp:featuredmedia"][0]["href"].stringValue
        
    }
    
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
