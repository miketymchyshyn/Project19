//
//  UserDetailsTableViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/19/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit
let addCarLabelText = "Add Car"
let userRowHeight: CGFloat = 140
let carRowHeight: CGFloat = 100
let vehiclesSectionTitle = "Your Cars & Motorcycles:"

class UserDetailsTableViewController: UITableViewController {
    
    var user: User!
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return user.cars.count + 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            // return user cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
            guard let userCell = cell as? UserTableViewCell else {
                fatalError()
            }
            //set up user Cell
            userCell.userName.text = user.name
            if let userPhoto = user.userPhoto {
                userCell.userImage.image = userPhoto
            } else {
                userCell.userImage.image = UIImage(named: "noPhoto")
            }
            return userCell
        } else {
            // return car cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)
            guard let carCell = cell as? CarTableViewCell else {
                fatalError()
            }
            //set up car Cell
            if indexPath.row < user.cars.count {
                //user's cars
                carCell.carName.text = user.cars[indexPath.row].name
                if let carPhoto = user.cars[indexPath.row].carPhoto {
                    carCell.carImage.image = carPhoto
                } else {
                    carCell.carImage.image = UIImage(named: "noPhoto")
                }
                carCell.carImage.layer.cornerRadius = carCell.carImage.frame.height / 4
                carCell.carImage.clipsToBounds = true
                carCell.carImage.gestureRecognizers?.removeAll()
            } else {
                //"add car cell."
                carCell.carName.text = addCarLabelText
                carCell.carImage.image = UIImage(named: "addCar")
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapAddVehicle))
                carCell.carImage.isUserInteractionEnabled = true
                carCell.carImage.addGestureRecognizer(tapGestureRecognizer)
            }
            
            return carCell
        }
    }
    
    @objc func handleTapAddVehicle() {
        performSegue(withIdentifier: "SegueToAddVehicle", sender: nil)
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return userRowHeight
        } else {
            return carRowHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        } else if section == 1 {
            return vehiclesSectionTitle
        } else {
            return nil
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVehicleVC = segue.destination as? AddVehicleViewController {
            addVehicleVC.user = user
        }
    }
}
