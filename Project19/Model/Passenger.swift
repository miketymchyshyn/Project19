//
//  Passenger.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/28/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Foundation
import CoreLocation

class Passenger: User {
    var pickupLocation: CLLocationCoordinate2D!
    
    init(name: String, pickupLocation: CLLocationCoordinate2D) {
        super.init(name: name)
        self.pickupLocation = pickupLocation
    }
}
