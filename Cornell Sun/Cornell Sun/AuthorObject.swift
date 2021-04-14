//
//  AuthorObject.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import IGListKit
import Foundation

class AuthorObject: Codable {
    var name: String
    var avatarURL: URL?
    var bio: String?
    var link: String?
    var twitter: String?
    var linkedin: String?
    var email: String?
    var posts: [PostObject]?
    var postsPage: Int = 1 // Used only in AuthorDetailViewController

    init(name: String) {
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case name, bio, link, twitter, linkedin, email, posts
        case avatarURL = "avatar_url"
    }
}

class AuthorDetailObject: ListDiffable {
    var bio: String?
    var email: String?
    private var identifier = UUID().uuidString // unless we get an id
    var imageURL: URL?
    var linkedInLink: String?
    var name: String
    var twitterLink: String?

    init(bio: String?, email: String?, imageURL: URL?, linkedIn: String?, name: String, twitter: String?) {
        self.bio = bio
        self.email = email
        self.imageURL = imageURL
        self.linkedInLink = linkedIn
        self.name = name
        self.twitterLink = twitter
    }

    func diffIdentifier() -> NSObjectProtocol {
        return identifier as NSObjectProtocol
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if self === object { return true }
        guard let object = object as? AuthorDetailObject else { return false }
        return identifier == object.identifier
    }

}

extension Array where Element: AuthorObject {
    var byline: String {
        let names = self.map { $0.name }
        guard let last = names.last else { return "" }
        return names.count <= 2
            ? names.joined(separator: " and ")
            : names.dropLast().joined(separator: ", ") + ", and " + last
    }
}
