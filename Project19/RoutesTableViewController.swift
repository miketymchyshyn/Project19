//
//  RoutesTableViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/13/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit

let routeCellIdentifier = "RouteCell"

class RoutesTableViewController: UITableViewController {
    
    var loggedInUser: User!
    var routes = [Route]()
    
    @IBOutlet weak var addRouteButton: UIBarButtonItem!
    
    @IBAction func userDetails(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SegueToUserDetails", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshRoutes), for: .valueChanged)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //create mockup user here.
        let muser = User(name: "David Mockup")
        muser.setPhoto(image: UIImage(named: "DavidMockupPhoto")! )
        loggedInUser = muser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addRouteButton.isEnabled = loggedInUser.cars.count > 0 ? true : false
    }
    @objc func refreshRoutes() {
        routes = RequestManager.shared.getRoutes()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return routes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: routeCellIdentifier, for: indexPath)
        guard let routeCell = cell as? RouteTableViewCell else {
            fatalError("Cell downcast failed.")
        }
        let route = routes[indexPath.row]
        routeCell.driverName.text = route.driver.driverName
        routeCell.driverCar.text = route.driver.driverCarName
        routeCell.fromLocation.text = route.path.fromLocationDescription
        routeCell.toLocation.text = route.path.destinationLocationDescription
        routeCell.time.text = route.time.description
        
        return routeCell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        TODO: pick which segue to perform based on whether loggedInUser is the driver for selected route or not.
        //if yes
        performSegue(withIdentifier: "SegueToPickup", sender: self)
        //if not
//        performSegue(withIdentifier: "SegueToViewRouteDescription", sender: routes[indexPath.row])
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let descriptionVC = segue.destination as? RouteDescriptionViewController, let route = sender as? Route {
            descriptionVC.route = route
        }
        if let userDetailsVC = segue.destination as? UserDetailsTableViewController {
            userDetailsVC.user = loggedInUser
        }
        if let createRouteVC = segue.destination as? CreateRouteViewController {
            createRouteVC.driver = Driver(driverName: loggedInUser.name, driverCarName: (loggedInUser.cars.first?.name)!)
        }
    }
 

}
