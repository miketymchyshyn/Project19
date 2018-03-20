//
//  Car.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/19/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Foundation
import UIKit

class Car {
    private(set) var name: String
    private(set) var carPhoto: UIImage?
    private(set) var passengerSeatsCount: Int
    
    init(name: String, passengerSeatsCount: Int){
        self.name = name
        self.passengerSeatsCount = passengerSeatsCount
    }
    
    func setCarPhoto(photo: UIImage){
        self.carPhoto = photo
    }
}
