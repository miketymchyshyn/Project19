//
//  RequsetManager.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/13/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//


// How should I structure data for backend ?

// Hollow thing. Just simulating adding and getting a route.

import Foundation
import MapKit

class RequestManager {
    
    //Routes part. Yet to convert to HTTP mockups
    static let shared = RequestManager()
    
    private var routes = [Route]()
    
    func addRoute(route: Route){
        routes.append(route)
    }
    
    func getRoutes() -> [Route] {
        return routes
    }
    
    //User part.
    
    func createUser() {
        //
    }
    
    func addUserPhoto() {
        
    }
    
}
