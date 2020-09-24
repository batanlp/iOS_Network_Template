//
//  BaseResponse.swift
//  NetworkTemplate
//
//  Created by Nguyen Ba Tan - DC3 on 9/24/20.
//  Copyright © 2020 Nguyen Ba Tan - DC3. All rights reserved.
//

import UIKit


// Common struct for all JSon object response from API
// Ex:
/*
    {
        status: success
        message: OK
        data: {
            // Specific object data for each API
        }
    }
*/
class BaseResponse<T: Codable>: Codable {
    let status: String?
    let message: String?
    let data: T?
    let errorData: ErrorData?
}

class ErrorData: Codable {
    let code: String?
    let reason: String?
}

// Sample object for upload
class UploadResponse: Codable {
    let status: String?
    let message: String
}

// Sample object for an API
class TestObject: Codable {
    let a: String?
    let b: String?
}
