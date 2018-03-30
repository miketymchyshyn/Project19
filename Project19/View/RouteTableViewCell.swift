//
//  RouteTableViewCell.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/13/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var driverImage: UIImageView!    
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverCar: UILabel!
    
    @IBOutlet weak var fromLocation: UILabel!
    @IBOutlet weak var toLocation: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var places: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
