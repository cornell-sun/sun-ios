//
//  SunAPI.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 7/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import Moya

var defaultPath = "/wp/v2"
var backendPath = "/sun-backend-extension/v1"

enum SunAPI {

    //Posts
    case post(postId: Int)
    case posts(page: Int)
    case postsFor(authorName: String, page: Int)

    //section
    case section(section: Int, page: Int)

    //Authors
    case author(authorName: String)

    //images
    case media(mediaId: String)

    //categories
    case category(categoryId: Int)

    //comments
    case comments(postId: Int)

    //trending
    case trending

    case search(query: String, page: Int)

    //featured post
    case featured

    //url to id
    case urlToID(url: URL)
}

extension SunAPI: TargetType {

    var headers: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
    
//        var baseURL: URL { return URL(string: "http://cornellsun.staging.wpengine.com/wp-json")! } //dev url
    var baseURL: URL { return URL(string: "http://cornellsun.com/wp-json")! } //production url
    
    var path: String {
        switch self {
        case .posts, .search, .section:
            return "\(defaultPath)/posts"
        case .postsFor(let authorName, _):
            let cleanedAuthor = cleanString(authorName)
            return "\(backendPath)/author/\(cleanedAuthor)"
        case .author(let authorName):
            let cleanedAuthor = cleanString(authorName)
            return "\(backendPath)/author/\(cleanedAuthor)"
        case .media(let mediaId):
            return "\(defaultPath)/media/" + mediaId
        case .category(let categoryId):
            return "\(defaultPath)/categories/\(categoryId)"
        case .comments(let postID):
            return "\(backendPath)/comments/\(postID)"
        case .trending:
            return "\(backendPath)/trending"
        case .featured:
            return "\(backendPath)/featured"
        case .post(let postID):
            return "\(defaultPath)/posts/\(postID)"
        case .urlToID:
            return "\(backendPath)/urltoid/"
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
        case .post(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .posts(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .postsFor(_, let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .author:
            return .requestParameters(parameters: ["page": 1], encoding: URLEncoding.default)
        case .comments(let postId):
            return .requestParameters(parameters: ["post": postId], encoding: URLEncoding.default)
        case .search(let query, let page):
            return .requestParameters(parameters: ["search": query, "page": page], encoding: URLEncoding.default)
        case .section(let section, let page):
            return .requestParameters(parameters: ["categories": section, "page": page], encoding: URLEncoding.default)
        case .urlToID(url: let url):
            return .requestParameters(parameters: ["url": url], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }

    func cleanString(_ string: String) -> String {
        return string.replacingOccurrences(of: " ", with: "+")
    }
}
