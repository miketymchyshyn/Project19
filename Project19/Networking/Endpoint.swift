//
//  Endpoint.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/27/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Alamofire

protocol Endpoint {
    var baseURL: String { get } // https://example.com
    var path: String { get } // /users/
    var fullURL: String { get } // This will automatically be set. https://example.com/users/
    var method: HTTPMethod { get } // .get
    var encoding: ParameterEncoding { get } // URLEncoding.default
    var body: Parameters { get } // ["foo" : "bar"]
    var headers: HTTPHeaders { get } // ["Authorization" : "Bearer SOME_TOKEN"]
}

extension Endpoint {
    // The encoding's are set up so that all GET requests parameters
    // will default to be url encoded and everything else to be json encoded
    var encoding: ParameterEncoding {
        return method == .get ? URLEncoding.default : JSONEncoding.default
    }
    
    // Should always be the same no matter what
    var fullURL: String {
        return baseURL + path
    }
    
    // A lot of requests don't require parameters
    // so we just set them to be empty
    var body: Parameters {
        return Parameters()
    }
}
