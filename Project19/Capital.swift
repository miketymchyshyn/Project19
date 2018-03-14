//
//  Capital.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/8/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//
import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D,
         info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
