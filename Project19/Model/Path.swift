//
//  Path.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/14/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Foundation
import MapKit

struct Path {
//    let startLocation: CLLocationCoordinate2D
//    let startLocationDescription: String
//    let endLocation: CLLocationCoordinate2D
//    let endLocationDescription: String
//    let route: MKRoute
//
//    init(startLocation: CLLocationCoordinate2D, startLocationDescription: String, endLocation: CLLocationCoordinate2D, endLocationDescription: String, route: MKRoute) {
//        self.startLocation = startLocation
//        self.startLocationDescription = startLocationDescription
//        self.endLocation = endLocation
//        self.endLocationDescription = endLocationDescription
//        self.route = route
//    }    
    var from: CLLocationCoordinate2D?
    var fromLocationDescription: String?
    var stop: CLLocationCoordinate2D?
    var stopLocationDescription: String?
    var destination: CLLocationCoordinate2D?
    var destinationLocationDescription: String?
    
}
