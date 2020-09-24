//
//  Networking.swift
//  NetworkTemplate
//
//  Created by Nguyen Ba Tan - DC3 on 9/24/20.
//  Copyright © 2020 Nguyen Ba Tan - DC3. All rights reserved.
//

import UIKit

protocol NetworkingDelegate: NSObjectProtocol {
    func sendProgress(progress: Float)
}

class Networking: NSObject {
    weak var delegate: NetworkingDelegate?
    private let session: URLSession

    override init() {
        self.session = URLSession(configuration: .default)
    }
    
    func addDefauldHeader(url: String) -> URLRequest {
        var request = URLRequest(url: URL(string: url)!)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // ...
        
        return request
    }
    
    // Func to call API
    func performNetworkTask<T: Codable>(endpoint: ApiServices,
                                    type: T.Type?,
                                    completion: ((_ response: T?) -> ())?,
                                    errorCompletion: ((_ messages: String?) -> ())?) {
        
        var urlString = "\(endpoint.baseURL)\(endpoint.path)"
        
        // Encode API to avoid special characters
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        var request = self.addDefauldHeader(url: urlString)
        request.httpMethod = endpoint.method
        if (endpoint.header_auth != "") {
            // Add auth if needed
            request.addValue(endpoint.header_auth, forHTTPHeaderField: "Authorization")
        }
        
        // Log API Info, if have: create a class for logging
        if (endpoint.method != "GET") {
            let jsonData = try? JSONSerialization.data(withJSONObject: endpoint.parameters)
            request.httpBody = jsonData
           
            print("========")
            print("Body:")
            print(String(data: request.httpBody!, encoding: .utf8)!)
        }
        print("========")
        print("URL: \(urlString)")
        print("Method: \(endpoint.method)")
        print("Header:")
        print(request.allHTTPHeaderFields!)
        
        let urlSession = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                errorCompletion?("Unknow Error")
                return
            }
            guard let data = data else {
                errorCompletion?("Unknow Error")
                return
            }
            
            // Log response
            let responseData = String(data: data, encoding: String.Encoding.utf8)
            print("Json data for: \(urlString)")
            print(responseData!)
            
            // Parse reponse data to BaseResponse object
            let response = Response(results: data)
            guard let decoded = response.decode(type!) else {
                return (errorCompletion?("Unknow Error"))!
            }
            completion?(decoded)
        }
        urlSession.resume()
    }
    
    // Demo func for upload data, the same with download
    func uploadMedia(urlPath: URL, completion: ((_ response: UploadResponse?) -> ())?,
                     errorCompletion: (() -> ())?) {
        
        guard let url = URL(string: "api.batanlp.vn/mobile/v1/upload") else {
            return
        }
        
        print("url: \(url.absoluteString)")
        var request = URLRequest(url: url)
        let boundary = "------------------------iOS_batanlp"
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // ...
        request.addValue("auth token here if needed", forHTTPHeaderField: "Authorization")
        var uploadData: Data?
        do {
            uploadData = try Data(contentsOf: urlPath, options: Data.ReadingOptions.alwaysMapped)
        } catch _ {
            uploadData = nil
            return
        }
       
        var body = Data()
        
        // Create body data for Upload, change base on your requirement
        let filename = "uploadTest.mp4"
        let mimetype = "video/mp4"
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
        
        // Upload data
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(uploadData!)
        
        // Upload addition information
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"title\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("\(filename)\r\n".data(using: String.Encoding.utf8)!)
        
        // For one field
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"description\"\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append("Desc Info\r\n".data(using: String.Encoding.utf8)!)
        // add more if you need
        
        // End of body
        body.append("--\(boundary)--".data(using: String.Encoding.utf8)!)
               
        request.httpBody = body
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        
        let task = session.dataTask(with: request) { (data: Data?, reponse: URLResponse?, error: Error?) in
            DispatchQueue.main.async {
                if let `error` = error {
                    print(error)
                    errorCompletion?()
                    return
                }
                if let `data` = data {
                    let responseData = String(data: data, encoding: String.Encoding.utf8)
                    // Parse reponse result
                    print(responseData!)
                    let response = Response(results: data)
                    guard let decoded = response.decode(UploadResponse.self) else {
                        return (errorCompletion?())!
                    }
                    completion?(decoded)
                }
            }
        }
        
        task.resume()
    }
}

// Upload percent if need
extension Networking: URLSessionDelegate, URLSessionDataDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let uploadProgress:Float = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        
        self.delegate?.sendProgress(progress: uploadProgress)
    }
}
