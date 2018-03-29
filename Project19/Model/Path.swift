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
    var from: CLLocationCoordinate2D?
    var fromLocationDescription: String?
    var stop: CLLocationCoordinate2D?
    var stopLocationDescription: String?
    var destination: CLLocationCoordinate2D?
    var destinationLocationDescription: String?    
}
