//
//  EndpointType.swift
//  NetworkTemplate
//
//  Created by Nguyen Ba Tan - DC3 on 9/24/20.
//  Copyright © 2020 Nguyen Ba Tan - DC3. All rights reserved.
//

import UIKit

// Define all field of an API need
protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
    var method: String { get }
    var parameters: Dictionary<String, Any> { get }
    var header_auth: String { get }
}
