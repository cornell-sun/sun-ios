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
let savedPostIds: [Int] = Array(RealmManager.instance.get()).map({$0.id})

func fetchPosts(target: SunAPI, completion: @escaping PostObjectCompletionBlock) {
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
                    if let post = PostObject(dictionary: postDictionary) {
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

func prepareInitialPosts(callback: @escaping ([PostObject], PostObject?) -> Void) {
    var headlinePost: PostObject?
    var postObjects: [PostObject] = []

    let group = DispatchGroup()

    // uncomment when backend is fixed
//    group.enter()
//    API.request(target: .featured) { (response) in
//        if let response = response {
//            do {
//                let json = try JSONSerialization.jsonObject(with: response.data, options: [])
//                if let postDictionary = json as? [String: Any], let post = PostObject(dictionary: postDictionary) {
//                    if savedPostIds.contains(post.id) {
//                        post.didSave = true
//                    }
//                    headlinePost = post
//                }
//            } catch {
//                fatalError()
//            }
//        }
//        group.leave()
//    }

    group.enter()
    API.request(target: .posts(page: 1)) { (response) in
        if let response = response {

            do {
                let json = try JSONSerialization.jsonObject(with: response.data, options: [])
                if let postArray = json as? [[String: Any]] {
                    for postDictionary in postArray {
                        if let post = PostObject(dictionary: postDictionary) {
                            if savedPostIds.contains(post.id) {
                                post.didSave = true
                            }
                            //temporary
                            if headlinePost == nil {
                                headlinePost = post
                            }
                            postObjects.append(post)
                        }
                    }
                }
            } catch {
                fatalError()
            }
        }

        group.leave()
    }

    group.notify(queue: .main) {
        //both network requests are done
        postObjects = postObjects.filter { post in
            return post.id != headlinePost?.id
        }
        callback(postObjects, headlinePost)
    }
}
