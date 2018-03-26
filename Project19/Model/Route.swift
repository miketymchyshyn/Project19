//
//  Route.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/14/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Foundation
import MapKit

class Route {
    let driver: Driver
    let path: Path
    let routes: [MKRoute]
    var time: Date
    let maxPlaces: Int
    var placesTaken: Int = 0
//  var passengers: [Passenger]
    
    init (driver: Driver, path: Path, time: Date, maxPlaces: Int, routes: [MKRoute]) {
        self.driver = driver
        self.path = path
        self.time = time
        self.maxPlaces = maxPlaces
        self.routes = routes
    }
}
