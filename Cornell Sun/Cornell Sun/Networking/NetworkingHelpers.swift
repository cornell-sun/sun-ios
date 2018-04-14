//
//  NetworkingHelpers.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 2/4/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

enum APIErrors: Error {
    case networkingError
    case parsingError
    case noResultsError
}

typealias PostObjectCompletionBlock = (_ posts: [PostObject], _ error: APIErrors?) -> Void
typealias TrendingCompletionBlock = (_ trending: [String], _ error: APIErrors?) -> Void
typealias CommentsCompletionBlock = (_ comments: [CommentObject], _ error: APIErrors?) -> Void
let savedPosts: Results<PostObject> = RealmManager.instance.get()

func fetchPosts(target: SunAPI, completion: @escaping PostObjectCompletionBlock) {
    let savedPostIds: [Int] = savedPosts.map({$0.id})
    var postObjects: [PostObject] = []
    API.request(target: target) { response in
        guard let response = response else {
            completion(postObjects, .networkingError)
            return
        }
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: [])
            if let postArray = jsonResult as? [[String: Any]] {
                for postDictionary in postArray {
                    if let post = PostObject(data: postDictionary) {
                        if savedPostIds.contains(post.id) {
                            post.didSave = true
                        }
                        postObjects.append(post)
                    }
                }
            } else {
                completion(postObjects, .noResultsError)
            }
        } catch {
            completion(postObjects, .parsingError)
            return
        }
        completion(postObjects, nil)
    }
}

func getTrending(completion: @escaping TrendingCompletionBlock) {
    API.request(target: .trending) { response in
        guard let response = response else { return }
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: [])
            if let trending = jsonResult as? [String] {
                completion(trending, nil)
            }
        } catch {
            print("could not parse")
            completion([String](), .parsingError)
        }
    }
}

func getComments(postID: Int, completion: @escaping CommentsCompletionBlock) {
    API.request(target: .comments(postId: postID)) { response in
        guard let response = response else { return }
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: [])
            if let rawCommentsArray = jsonResult as? [[String: AnyObject]] {
                var commentsArray = [CommentObject]()
                rawCommentsArray.forEach {
                    if let comment = CommentObject(data: $0) {
                        commentsArray.append(comment)
                    }
                }
                completion(commentsArray, nil)
            }
        } catch {
            print("error parsing comments")
            completion([CommentObject](), .parsingError)
        }
    }
}

var headlinePost: PostObject?
func setUpData(callback: @escaping ([PostObject], PostObject?) -> Void) {
    let savedPostIds: [Int] = savedPosts.map({$0.id})
    var postObjects: [PostObject] = []
    API.request(target: .posts(page: 1)) { (response) in
        guard let response = response else {return callback(postObjects, headlinePost) }
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: [])
            if let postArray = jsonResult as? [[String: Any]] {
                for postDictionary in postArray {
                    if let post = PostObject(data: postDictionary) {
                        if headlinePost == nil {
                            headlinePost = post
                        }
                        if savedPostIds.contains(post.id) {
                            post.didSave = true
                        }
                        postObjects.append(post)
                    }
                }
            }
            callback(postObjects, headlinePost)
        } catch {
            print("could not parse")
            callback(postObjects, headlinePost)
            // can't parse data, show error
        }
    }
}
