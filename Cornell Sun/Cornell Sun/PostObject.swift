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
import RealmSwift
import Realm

// swiftlint:disable:next type_name
enum postTypeEnum: String {
    case article
    case photoGallery
}

class PostObject: Object, ListDiffable {

    private let wpDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"     // "2016-01-29T01:45:33"
        return formatter
    }()

    @objc dynamic var fakeDelete = false
    @objc dynamic var id: Int = 0
    @objc dynamic var datePosted: Date = Date()
    @objc dynamic var link: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var content: String = ""
    @objc dynamic var excerpt: String = ""
    @objc dynamic var author: AuthorObject? = nil
    @objc dynamic var primaryCategory: String = ""
    var categories = List<String>()
    var tags = List<String>()
    var comments = List<CommentObject>()
    var photoGalleryObjects = List<PhotoGalleryObject>()
    @objc dynamic var mediumLargeImageLink: String = ""
    @objc dynamic var thumbnailImageLink: String = ""
    @objc dynamic var fullImageLink: String = ""
    @objc dynamic var typeEnum = postTypeEnum.article.rawValue
    @objc dynamic var didSave = false
    var postType: postTypeEnum {
        get {
            return postTypeEnum(rawValue: typeEnum)!
        }
        set {
            typeEnum  = newValue.rawValue
        }
    }

    convenience init?(data: [String: Any]) {
        self.init()
        guard
        let id = data["id"] as? Int,
        let dateString = data["date"] as? String,
        let date = wpDateFormatter.date(from: dateString),
        let titleDictionary = data["title"] as? [String: Any],
        let title = titleDictionary["rendered"] as? String,
        let contentDictionary = data["content"] as? [String: Any],
        let content = contentDictionary["rendered"] as? String,
        let excerptDictionary = data["excerpt"] as? [String: Any],
        let excerpt = excerptDictionary["rendered"] as? String,
        let link = data["link"] as? String,
        let categoriesArray = data["category_strings"] as? [String],
        let primaryCategory = data["primary_category"] as? String,
        let authorId = data["author"] as? Int,
        let postTypeString = data["post_type_enum"] as? String,
        let postTypeEnum = postTypeEnum(rawValue: postTypeString),
        let featuredMediaDictionary = data["featured_media_url_string"] as? [String: Any],
        let mediumLargeDictionary = featuredMediaDictionary["medium_large"] as? [String: Any],
        let thumbnailDictionary = featuredMediaDictionary["thumbnail"] as? [String: Any],
        let fullDictionary = featuredMediaDictionary["full"] as? [String: Any],
        let mediumLargeImageLink = mediumLargeDictionary["url"] as? String,
        let thumbnailImageLink = thumbnailDictionary["url"] as? String,
        let fullImageLink = fullDictionary["url"] as? String,
        let tagsArray = data["tag_strings"] as? [String],
        let authorDictionary = data["author_dict"] as? [Any]
        else {
            print("going to return nil")
            return nil
        }
        var photoGalleryObjects: [PhotoGalleryObject] = []

        var authorName = "Unknown"
        var authorLink = ""
        var bio = ""
        var avatarLink = ""

        //Author Processing
        if let authorEntry = authorDictionary.first as? [String: Any], let name = authorEntry["name"] as? String {
            authorName = name
            if let avatarUrl = authorEntry["avatar_url"] as? String, let authorBio = authorEntry["bio"] as? String, let link = authorEntry["link"] as? String {
                authorLink = link
                bio = authorBio
                avatarLink = avatarUrl
            }
        }
        let postCommentsArray: [String: Any] = [:]

        let authorObject = AuthorObject(id: authorId, name: authorName, link: authorLink, bio: bio, avatarLink: avatarLink)

        var commentsArray: [CommentObject] = []

        for comment in postCommentsArray {
        }

        if postTypeEnum == .photoGallery, let postAttachmentsArray = data["post_attachments_meta"] as? [Any] {
            //process photogallery stuff
            for postAttachment in postAttachmentsArray {
                guard
                    let postAttachment = postAttachment as? [String: Any],
                    let photoGalleryObject = PhotoGalleryObject(data: postAttachment)
                    else { break }
                photoGalleryObjects.append(photoGalleryObject)
            }

        }
        let categoriesList = List<String>()
        categoriesList.append(objectsIn: categoriesArray)

        let tagsList = List<String>()
        tagsList.append(objectsIn: tagsArray)

        let commentsList = List<CommentObject>()
        commentsList.append(objectsIn: commentsArray)

        let photoGalleryList = List<PhotoGalleryObject>()
        photoGalleryList.append(objectsIn: photoGalleryObjects)

        self.id = id
        self.datePosted = date
        self.title = title.removingHTMLEntities
        self.content = content.htmlToString
        self.link = link
        self.excerpt = excerpt
        self.primaryCategory = primaryCategory.removingHTMLEntities
        self.categories = categoriesList
        self.tags = tagsList
        self.mediumLargeImageLink = mediumLargeImageLink
        self.thumbnailImageLink = thumbnailImageLink
        self.fullImageLink = fullImageLink
        self.author = authorObject
        self.postType = postTypeEnum
        self.comments = commentsList
        self.photoGalleryObjects = photoGalleryList
        cacheImage(imageLink: mediumLargeImageLink)
    }

    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }

    required init() {
        super.init()
    }

    func diffIdentifier() -> NSObjectProtocol {
        var idDiff = -9999999
        if !isInvalidated {
            idDiff = id
        }
        return idDiff as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true } else {
            return false
        }
    }

}
