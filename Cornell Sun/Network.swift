//
//  Network.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 4/29/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import TRON
import SwiftyJSON

class Error: JSONDecodable {
    required init(json: JSON) {
        
    }
}

class Network {
    static let tron = TRON(baseURL: "http://cornellsun.com//wp-json/wp/v2/")
    
    class func getPosts() -> APIRequest<Array<PostObject>,Error> {
        let request: APIRequest<Array<PostObject>,Error> = tron.request("posts")
        let parameters = ["per_page": 30]
        request.parameters = parameters
        request.method = .get
        return request
    }
    
    class func getAuthor(id: Int) -> APIRequest<AuthorObject, Error> {
        let request: APIRequest<AuthorObject, Error> = tron.request("users/\(id)")
        request.method = .get
        return request
    }
    
}








extension Array : JSONDecodable {
    public init(json: JSON) {
        self.init(json.arrayValue.flatMap {
            if let type = Element.self as? JSONDecodable.Type {
                let element : Element?
                do {
                    element = try type.init(json: $0) as? Element
                } catch {
                    return nil
                }
                return element
            }
            return nil
        })
    }
}
