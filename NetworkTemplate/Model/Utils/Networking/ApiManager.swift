//
//  ApiManager.swift
//  NetworkTemplate
//
//  Created by Nguyen Ba Tan - DC3 on 9/24/20.
//  Copyright © 2020 Nguyen Ba Tan - DC3. All rights reserved.
//

import UIKit

// Main class hold all API and call network
class ApiManager {
    
    var networking = Networking()
    init() {}
    
    func requestAPI<T: Codable>(responseObject: T.Type,
                                apiService: ApiServices,
                                completion: ((_ data: T?) -> ())?,
                                errorCompletion: ((_ messages: String?) -> ())?,
                                showLoading: Bool = true) {
        if (showLoading) {
            DispatchQueue.main.async {
                // Add loading view here
            }
        }
        
        networking.performNetworkTask(endpoint: apiService, type: BaseResponse<T>.self, completion: { (response) in
            DispatchQueue.main.async {
                if (showLoading) {
                    // Remove loading view here
                }
                
                // If needed, handle reponse code here ...
                completion?(response?.data)
            }
        }) { (errorMessages) in
            DispatchQueue.main.async {
                errorCompletion?(errorMessages)
            }
        }
    }
}

extension ApiManager {
    func testApi(page: Int, onSuccess: ((_ data: Any?) -> ())?, onError: ((_ messages: String?) -> ())?) {
        self.requestAPI(responseObject: TestObject.self, apiService: .testAPI(page: page), completion: { object in
            onSuccess?(object)
        }, errorCompletion: { msg in
            onError?(msg)
        })
    }
}
