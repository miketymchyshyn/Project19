//
//  UserEndpoints.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/27/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.

import Alamofire

// Create an Endpoint
enum UserService {
    case getUsers
    case getUser(id: Int)
    case createUser(firstName: String, lastName: String)
}

extension UserService: Endpoint {
    var baseURL: String { return "https://example.com/" }
    
    // Set up the paths
    var path: String {
        switch self {
        case .getUsers: return "users/"
        case .getUser(let id): return "users/\(id)/"
        case .createUser: return "users/"
        }
    }
    
    // Set up the methods
    var method: HTTPMethod {
        switch self {
        case .getUsers: return .get
        case .getUser: return .get
        case .createUser: return .post
        }
    }
    
    // Set up any headers you may have. You can also create an extension on `Endpoint` to set these globally.
    var headers: HTTPHeaders {
        return ["Authorization" : "Bearer SOME_TOKEN"]
    }
    
    // Lastly, we set the body. Here, the only route that requires parameters is create.
    var parameters: Parameters {
        var parameters: Parameters = Parameters()
        
        switch self {
        case .createUser(let firstName, let lastName):
            parameters["first_name"] = firstName
            parameters["last_name"] = lastName
        default:
            break
        }
        
        return parameters
    }
}
