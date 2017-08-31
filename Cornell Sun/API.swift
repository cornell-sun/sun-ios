//
//  API.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 7/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import Foundation
import Moya

/* EXAMPLE OF USING THE API
API.request(target: .recentPosts, success: { (response) in
    // parse your data
    do {
        let posts: [PostObject] = try response.mapArray() as [PostObject]
        // do something with Posts
    } catch {
        // can't parse data, show error
    }
}, error: { (error) in
    // error from Wordpress
}, failure: { (error) in
    // show Moya error
})
*/

struct API {
    static let provider = MoyaProvider<SunAPI>()

    static func request(target: SunAPI, success successCallback: @escaping (Response) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {

        provider.request(target) { (result) in
            switch result {
            case .success(let response):
                // 1:
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    successCallback(response)
                } else {
                    // 2:
                    let error = NSError(domain:"com.cornellsun.networkLayer", code:0, userInfo:[NSLocalizedDescriptionKey: "Parsing Error"])
                    errorCallback(error)
                }
            case .failure(let error):
                // 3:
                failureCallback(error)
            }
        }
    }
}
