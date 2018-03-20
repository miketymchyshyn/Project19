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
// Is a User

class Driver {
    let driverID: String
    
    let driverName: String
    var driverImage: UIImage?
    let driverCarName: String
    var driverCarImage: UIImage?
    
    init(driverID: String, driverName: String, driverCarName: String) {
        self.driverID = driverID
        self.driverName = driverName
        self.driverCarName = driverCarName
    }
}
