//
//  Bucko.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/27/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Alamofire

protocol BuckoErrorHandler {
    func buckoRequest(request: URLRequest, error: Error)
}

typealias ResponseClosure = ((DataResponse<Any>) -> Void)

struct Bucko {
    // You can set this to a var if you want
    // to be able to create your own SessionManager
    let manager: SessionManager = SessionManager()
    static let shared = Bucko()
    var delegate: BuckoErrorHandler?
}

extension Bucko {
    func request(endpoint: Endpoint, completion: @escaping ResponseClosure) -> Request {
        let request = manager.request(
            endpoint.fullURL,
            method: endpoint.method,
            parameters: endpoint.body,
            encoding: endpoint.encoding,
            headers: endpoint.headers
            ).responseJSON { response in
                
                if response.result.isSuccess {
                    debugPrint(response.result.description)
                } else {
                    debugPrint(response.result.error ?? "Error")
                    // Can globably handle errors here if you want
                    if let urlRequest = response.request, let error = response.result.error {
                        self.delegate?.buckoRequest(request: urlRequest, error: error)
                    }
                }
                
                completion(response)
        }
        
        print(request.description)
        return request
    }
}
