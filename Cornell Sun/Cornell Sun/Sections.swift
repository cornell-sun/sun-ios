//
//  Sections.swift
//  Cornell Sun
//
//  Created by Cameron Hamidi on 11/22/20.
//  Copyright © 2020 cornell.sun. All rights reserved.
//

import Foundation

enum Sections {

    case news(id: Int)
    case opinion(id: Int)
    case sports(id: Int)
    case arts(id: Int)
    case science(id: Int)
    case dining(id: Int)
    case multimedia(id: Int)

    static let allSections: [Sections] = [.news(id: 2), .opinion(id: 3), .sports(id: 4), .arts(id: 5), .science(id: 6), .dining(id: 7), .multimedia(id: 9)]

}
