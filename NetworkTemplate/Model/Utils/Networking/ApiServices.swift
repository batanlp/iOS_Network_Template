//
//  ApiServices.swift
//  NetworkTemplate
//
//  Created by Nguyen Ba Tan - DC3 on 9/24/20.
//  Copyright © 2020 Nguyen Ba Tan - DC3. All rights reserved.
//

import Foundation

// Where to define all API and create API field
public enum ApiServices {
    case testAPI(page: Int)
}

extension ApiServices: EndpointType {
    var baseURL: URL {
        return URL(string: "api.batanlp.com/mobile/v1/")!
    }
    
    var path: String {
        switch self {
        case .testAPI(let page):
            return "?page=\(page)&pageSize=10"
        }
    }
    
    var method: String {
        switch self {
        default:
            return "GET"
        }
    }
    
    var parameters: Dictionary<String, Any> {
        switch self {
        default:
            return [:]
        }
    }
    
    var header_auth: String {
        switch self {
        default:
            return ""
        }
    }
}
