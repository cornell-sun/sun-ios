//
//  APITests.swift
//  Cornell SunTests
//
//  Created by Austin Astorga on 7/23/17.
//  Copyright © 2017 cornell.sun. All rights reserved.
//

import XCTest
@testable import Cornell_Sun

class APITests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        API.request(target: .recentPosts, success: { (response) in
            // parse your data
            do {
                print(response)
                //XCTAssert(5==5)
//                let posts: [PostObject] = try response.mapArray() as [PostObject]
//                print(posts)
                // do something with Posts
            } catch {
                // can't parse data, show error
            }
        }, error: { (error) in
            // error from Wordpress
        }, failure: { (_) in
            // show Moya error
        })
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
