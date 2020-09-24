//
//  Response.swift
//  NetworkTemplate
//
//  Created by Nguyen Ba Tan - DC3 on 9/24/20.
//  Copyright © 2020 Nguyen Ba Tan - DC3. All rights reserved.
//

import UIKit

// Auto parse Json data to BaseReponse Object
struct Response {
    fileprivate var results: Data
    init(results: Data) {
        self.results = results
    }
}

extension Response {
    public func decode<T: Codable>(_ type: T.Type) -> T? {
        let jsonDecoder = JSONDecoder()
        do {
            let response = try jsonDecoder.decode(T.self, from: results)
            return response
        } catch _ {
            return nil
        }
    }
}
