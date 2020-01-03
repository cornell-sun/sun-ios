//
//  NetworkingHelpers.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 2/4/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import Foundation
import IGListKit

enum APIErrors: Error {
    case networkingError
    case parsingError
    case noResultsError
}

typealias PostObjectCompletionBlock = (_ posts: [PostObject], _ error: APIErrors?) -> Void
typealias TrendingCompletionBlock = (_ trending: [String], _ error: APIErrors?) -> Void
typealias CommentsCompletionBlock = (_ comments: [CommentObject], _ error: APIErrors?) -> Void

let savedPostIds: [Int] = {
    guard let posts = PostOffice.instance.get() else { return [] }
    return posts.map { $0.id }
}()

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    return formatter
}()

let decoder: JSONDecoder = {
    let coder = JSONDecoder()
    coder.dateDecodingStrategy = .formatted(dateFormatter)
    return coder
}()

func fetchPosts(target: SunAPI, completion: @escaping PostObjectCompletionBlock) {
    var postObjects: [PostObject] = []
    API.request(target: target) { response in
        guard let response = response else {
            completion(postObjects, .networkingError)
            return
        }
        do {
            postObjects = try decoder.decode([PostObject].self, from: response.data)
            completion(postObjects, .noResultsError)
        } catch let error {
            print(error)
            completion(postObjects, .parsingError)
            return
        }
        completion(postObjects, nil)
    }
}

func getTrending(completion: @escaping TrendingCompletionBlock) {
    API.request(target: .trending) { response in
        guard
            let response = response,
            let trending = try? decoder.decode([String].self, from: response.data)
            else { completion([String](), .parsingError); return }
        completion(trending, nil)
    }
    completion([String](), nil)
}

func getComments(postID: Int, completion: @escaping CommentsCompletionBlock) {
    API.request(target: .comments(postId: postID)) { response in
        guard let response = response else { return }
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: response.data, options: [])
            if let rawCommentsArray = jsonResult as? [[String: AnyObject]] {
                var commentsArray = [CommentObject]()
                for comment in rawCommentsArray {
                    if let newComment = CommentObject(data: comment) {
                        commentsArray.append(newComment)
                    }
                }
                completion(commentsArray, nil)
            }
        } catch {
            print("error parsing comments")
            completion([CommentObject](), .parsingError)
        }
    }
    completion([CommentObject](), .parsingError)
}

func getPostsFromIDs(_ ids: [Int], completion: @escaping ([Int: PostObject], APIErrors?) -> Void) {
    let group = DispatchGroup()
    var postsDict = [Int: PostObject]()
    
    ids.forEach { id in
        group.enter()
        API.request(target: .post(postId: id)) { response in
            guard let response = response else {
                print("error")
                return
            }
            
            do {
                let post = try decoder.decode(PostObject.self, from: response.data)
                postsDict[id] = post
            } catch let error {
                print(error)
                return
            }
            
        }
        group.leave()
    }
    
    group.notify(queue: .main) {
        completion(postsDict, nil)
    }
}

func getPostFromID(_ id: Int, completion: @escaping (PostObject) -> Void) {
    API.request(target: .post(postId: id)) { response in
        guard let response = response else {
            print("Error fetching post by id: \(id)")
            fatalError()
        }
        do {
            let post = try decoder.decode(PostObject.self, from: response.data)
            completion(post)
        } catch let error {
            print("Error: \(error)")
            fatalError()
        }
    }
    fatalError()
}

func getIDFromURL(_ url: URL, completion: @escaping (Int?) -> Void) {
    API.request(target: .urlToID(url: url)) { response in
        guard let tryID = ((try? response?.mapString()) as String??), let idString = tryID, let id = Int(idString), id != 0 else {
            completion(nil)
            return
        }
        completion(id)
    }
    completion(0)
}

func prepareInitialPosts(callback: @escaping ([ListDiffable], PostObject?) -> Void) {
    var headlinePost: PostObject?
    var postObjects: [ListDiffable] = []
    
    let group = DispatchGroup()
    
    group.enter()
    API.request(target: .featured) { (response) in
        if let response = response {
            do {
                let featuredPost = try decoder.decode(PostObject.self, from: response.data)
                featuredPost.didSave = savedPostIds.contains(featuredPost.id)
                headlinePost = featuredPost
            } catch let error {
                print(error)
                return
            }
        }
        group.leave()
    }
    
    group.enter()
    API.request(target: .posts(page: 1)) { (response) in
        if let response = response {
            
            do {
                postObjects = try decoder.decode([PostObject].self, from: response.data)
                postObjects.insert("adToken" as ListDiffable, at: 7)
            } catch let error {
                print(error)
                return
            }
        }
        
        group.leave()
    }
    
    group.notify(queue: .main) {
        //both network requests are done
        postObjects = postObjects.filter { post in
            guard let post = post as? PostObject else { return true }
            return post.id != headlinePost?.id
        }
        callback(postObjects, headlinePost)
    }
}

func getDeeplinkedPostWithId(_ id: Int, completion: @escaping ([ListDiffable], PostObject?, PostObject?) -> Void) {
    let group = DispatchGroup()
    var posts: [ListDiffable] = []
    var heroPost: PostObject?
    var deeplinkPost: PostObject?
    
    group.enter()
    prepareInitialPosts { (postObjects, headlinePost) in
        posts = postObjects
        heroPost = headlinePost
        group.leave()
    }
    
    group.enter()
    getPostFromID(id) { post in
        deeplinkPost = post
        group.leave()
    }
    
    group.notify(queue: .main) {
        completion(posts, heroPost, deeplinkPost)
    }
}
