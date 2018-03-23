//
//  Path.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/14/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Foundation
import MapKit

class Path {
    let startLocation: CLLocationCoordinate2D
    let startLocationDescription: String
    let endLocation: CLLocationCoordinate2D
    let endLocationDescription: String
    let route: MKRoute

    init(startLocation: CLLocationCoordinate2D, startLocationDescription: String, endLocation: CLLocationCoordinate2D, endLocationDescription: String, route: MKRoute) {
        self.startLocation = startLocation
        self.startLocationDescription = startLocationDescription
        self.endLocation = endLocation
        self.endLocationDescription = endLocationDescription
        self.route = route
    }
}
