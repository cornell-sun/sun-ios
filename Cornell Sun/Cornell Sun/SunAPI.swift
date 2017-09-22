//
//  SunAPI.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 7/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import Moya

enum SunAPI {

    //Posts
    case post(postId: Int)
    case posts(page: Int)

    //Authors
    case author(authorId: Int)

    //images
    case media(mediaId: String)

}

extension SunAPI: TargetType {

    var headers: [String : String]? {
        switch self {
        default:
            return nil
        }
    }

    var baseURL: URL { return URL(string: "http://cornellsun.com/wp-json/wp/v2")! }

    var path: String {
        switch self {
        case .post(let postId):
            return "/posts/\(postId)"
        case .posts:
            return "/posts"
        case .author(let authorId):
            return "/users/\(authorId)"
        case .media(let mediaId):
            return "/media/" + mediaId
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    //Can be used for testing
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .posts(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)

        default:
            return .requestPlain
        }
    }
}
