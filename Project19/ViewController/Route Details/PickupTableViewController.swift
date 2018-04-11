//
//  PickupTableViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/27/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit
import MapKit

class PickupViewController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var route: Route! {
        didSet (newValue){
           places = newValue.maxPlaces
        }
    }
    var places: Int!
    
    //debug things.
    let passenger1 = Passenger(name: "Mark", pickupLocation: CLLocationCoordinate2D(latitude: 49.0, longitude: 28.0))
    let passenger2 = Passenger(name: "Jen", pickupLocation: CLLocationCoordinate2D(latitude: 49.0, longitude: 29.0))
    let passenger3 = Passenger(name: "Bob", pickupLocation: CLLocationCoordinate2D(latitude: 49.5, longitude: 28.5))
    let passenger4 = Passenger(name: "Alice", pickupLocation: CLLocationCoordinate2D(latitude: 49.5, longitude: 29.0))
    var passengers = [Passenger]()
   
    //end of debug things.
    var pickupAnnotations = [PickupAnnotation]()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        tableView.dataSource = self
        tableView.delegate = self
        
        //mockup passengers from route
        passengers.append(passenger1)
        passengers.append(passenger2)
        passengers.append(passenger3)
        passengers.append(passenger4)
        
        //create pickup annotaitons for every passenger.
        
        for passenger in passengers {
            
            let pickupAnnotation = PickupAnnotation(coordinate: passenger.pickupLocation, passengerName: passenger.name, markerColor: UIColor.random)
            pickupAnnotations.append(pickupAnnotation)
        }
        
        //place markers
        for pickupAnnotation in pickupAnnotations {
            placePickUpMarker(for: pickupAnnotation)
        }
    }
    
    func placePickUpMarker(for pickupAnnotation: PickupAnnotation){
        mapView.addAnnotation(pickupAnnotation)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else if annotation is PickupAnnotation{
           let pickupAnnotation = annotation as! PickupAnnotation
            let markerView = MKMarkerAnnotationView()
            //set marker color.
            markerView.markerTintColor = pickupAnnotation.markerColor
            return markerView
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pickupAnnotations.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let passengerCell = tableView.dequeueReusableCell(withIdentifier: "PassengerCell", for: indexPath) as! PassengerTableViewCell
        let pickupAnnotation = pickupAnnotations[indexPath.row]
        passengerCell.markerView.layer.backgroundColor = pickupAnnotation.markerColor.cgColor
        passengerCell.name.text = pickupAnnotation.title
        passengerCell.location.text = "nothing yet..."
        passengerCell.selectionStyle = .none
        return passengerCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pickupCoordinate = pickupAnnotations[indexPath.row].coordinate
        mapView.setCenter(pickupCoordinate, animated: true)
    }
}

extension UIColor {
    static var random: UIColor {
        // Seed (only once)
        srand48(Int(arc4random()))
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    }
}

class PickupAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var markerColor: UIColor
    
    init(coordinate: CLLocationCoordinate2D, passengerName: String, markerColor: UIColor){
        self.coordinate = coordinate
        title = passengerName
        self.markerColor = markerColor
    }
}
