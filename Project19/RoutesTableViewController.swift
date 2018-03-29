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
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refreshRoutes), for: .valueChanged)
        setupDateFormat()
        
        //mockup user. Real user should be loaded from back end using saved token.
        let muser = User(name: "David Mockup")
        muser.setPhoto(image: UIImage(named: "DavidMockupPhoto")! )
        loggedInUser = muser
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addRouteButton.isEnabled = loggedInUser.cars.count > 0
    }
    
    @objc func refreshRoutes() {
        routes = RequestManager.shared.getRoutes()
        tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
        routeCell.time.text = dateFormatter.string(from: route.time)
        
        //for demo purpose first route you create is highlighted yellow as if it is created by you.
        if indexPath.row == 0 {
            routeCell.layer.backgroundColor = UIColor.yellow.cgColor
        }
        
        return routeCell
    }
    
    //MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: pick which segue to perform based on whether loggedInUser is the driver for selected route or not.
        //for demo. first route is yours other routes are form other drivers.
        if indexPath.row == 0 {
            performSegue(withIdentifier: "SegueToPickup", sender: self)
        } else {
            performSegue(withIdentifier: "SegueToViewRouteDescription", sender: routes[indexPath.row])
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: segue to pickup
        
        //segue to route description.
        if let descriptionVC = segue.destination as? RouteDescriptionViewController, let route = sender as? Route {
            descriptionVC.route = route
        }
        //segue to user details.
        if let userDetailsVC = segue.destination as? UserDetailsTableViewController {
            userDetailsVC.user = loggedInUser
        }
        //segue to create route.
        if let createRouteVC = segue.destination as? CreateRouteViewController {
            //create a concrete driver form user info.
            createRouteVC.driver = Driver(driverName: loggedInUser.name, driverCarName: (loggedInUser.cars.first?.name)!)
        }
    }
    
    private func setupDateFormat(){
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
    }
}
