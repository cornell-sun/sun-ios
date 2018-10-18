//
//  MailchimpAPI.swift
//  Cornell Sun
//
//  Created by Austin Astorga on 7/6/18.
//  Copyright © 2018 cornell.sun. All rights reserved.
//

import Foundation
import Moya

enum MailchimpAPI {

    case subscribe(firstname: String, lastname: String, email: String)
}

extension MailchimpAPI: TargetType {

    var headers: [String: String]? {
        switch self {
        default:
            return ["Authorization": "apikey f1b0b2d8ae43f58174a5b924315f9e53-us11"]
        }
    }
    var baseURL: URL { return URL(string: "https://us11.api.mailchimp.com/3.0/lists/08b5503d55")! }
    var path: String {
        switch self {
        case .subscribe:
            return "/members"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }

    //Can be used for testing
    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case .subscribe(let firstname, let lastname, let email):
            return .requestParameters(parameters: ["email_address": email, "status": "pending", "merge_fields": ["FNAME": firstname, "LNAME": lastname, "MMERGE3": "14850"]], encoding: JSONEncoding
                .default)
        }
    }
}
