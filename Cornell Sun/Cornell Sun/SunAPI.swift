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
    case recentPosts

    //Authors
    case author(authorId: Int)
}

extension SunAPI: TargetType {
    var baseURL: URL { return URL(string: "http://cornellsun.com//wp-json/wp/v2")! }

    var path: String {
        switch self {
        case .post(let postId):
            return "/posts/\(postId)"
        case .recentPosts:
            return "/posts"
        case .author(let authorId):
            return "/users/\(authorId)"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
            //Use for POST Methods
        default:
            return nil
        }
    }

    //How to encode parameters in the request
    //You can choose between JSON Encoding (parameters will be set ass object in request body) and URL encoding (parameters will be in URL seperated by & symbol)
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }

    //Can be used for testing
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        return .request
    }


}





















