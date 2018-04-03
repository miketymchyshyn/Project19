//
//  Driver.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/14/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Foundation
import UIKit

// Actual driver for the route.
class Driver {
    let driverName: String
    var driverImage: UIImage?
    let driverCarName: String
    var driverCarImage: UIImage?
    var driverCarMaxSeatCount: Int
    
    init(driverName: String, driverCarName: String, seatCount: Int) {
        self.driverName = driverName
        self.driverCarName = driverCarName
        self.driverCarMaxSeatCount = seatCount
    }
}
