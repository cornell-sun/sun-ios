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

    init(name: String) {
        self.name = name
    }
}

class AuthorDetailObject: ListDiffable {
    var bio: String?
    var email: URL?
    private var identifier = UUID().uuidString // unless we get an id
    var imageURL: URL?
    var linkedInLink: URL?
    var name: String
    var twitterLink: URL?

    init(bio: String?, email: URL?, imageURL: URL?, linkedIn: URL?, name: String, twitter: URL?) {
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
        return names.count <= 2 ? names.joined(separator: " and ") : names.dropLast().joined(separator: ", ") + ", and " + last
    }
}
