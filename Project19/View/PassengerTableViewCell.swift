//
//  PassengerTableViewCell.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/28/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

class PassengerTableViewCell: UITableViewCell {
    @IBOutlet weak var markerView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var location: UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
