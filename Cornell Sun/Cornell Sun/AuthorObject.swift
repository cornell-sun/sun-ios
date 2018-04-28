//
//  AuthorObject.swift
//  Cornell Sun
//
//  Created by Mindy Lou on 4/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation

class AuthorObject: Codable {
    var name: String

    init(name: String) {
        self.name = name
    }
}

extension Array where Element: AuthorObject {
    var byline: String {
        let names = self.map { $0.name }
        guard let last = names.last else { return "" }
        return names.count <= 2 ? names.joined(separator: " and ") : names.dropLast().joined(separator: ", ") + ", and " + last
    }
}
