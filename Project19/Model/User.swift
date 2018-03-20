//
//  User.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/19/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import Foundation
import UIKit

class User {
    private(set) var name: String
    private(set) var userPhoto: UIImage?
    private(set) var cars = [Car]()
    
    init(name: String){
        self.name = name
    }
    
    func addCar(car: Car){
        cars.append(car)
    }
    
    func setPhoto(image: UIImage){
        self.userPhoto = image
    }
}
