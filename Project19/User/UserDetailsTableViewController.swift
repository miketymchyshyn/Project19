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
    
    /*
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */
    
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
            // return user cell for index zero
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
           // return car cell for index one and above
            let cell = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath)
            guard let carCell = cell as? CarTableViewCell else {
                fatalError()
            }
            //TODO: debug thing
            carCell.backgroundColor = #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1)
            //set up car Cell
            if indexPath.row < user.cars.count {
                carCell.carName.text = user.cars[indexPath.row].name
                if let carPhoto = user.cars[indexPath.row].carPhoto {
                    carCell.carImage.image = carPhoto
                } else {
                    carCell.carImage.image = UIImage(named: "noPhoto")
                }
            } else {
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
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - TableViewDelegate
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
            //            TODO: pass user cars to AddVehicleViewController.
            addVehicleVC.user = user
        }
    }
}
