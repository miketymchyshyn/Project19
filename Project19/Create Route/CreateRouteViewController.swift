//
//  CreateRouteViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/8/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit
import MapKit

class CreateRouteViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var whereToView: UIView!
    @IBOutlet weak var whereToTextField: UITextField!
    @IBOutlet weak var timePickerView: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    /// specific driver that creates a route.
    var driver: Driver!
    
    private var path: Path?
    private var routes = [MKRoute]()
    
    /// MapView Constraint to Bottom
    @IBOutlet weak var MVtoBottom: NSLayoutConstraint!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        whereToTextField.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelRouteCreation))
        
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    
    @objc func cancelRouteCreation() {
        timePickerView.isHidden = true
        whereToView.isHidden = false
        MVtoBottom.constant = 0
        removeRoute()
        path = nil
        routes.removeAll()
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: - showRouteOnMap
    func showRouteOnMap(path: Path) {
        self.path = path
        if path.from == nil {
            self.path?.from = mapView.userLocation.coordinate
            self.path?.fromLocationDescription = mapView.userLocation.title
        }
        
        //placemark for start.
        let fromPlacemark = MKPlacemark(coordinate: (self.path?.from)!)
        let fromMapItem = MKMapItem(placemark: fromPlacemark)
        let fromAnnotaion = MKPointAnnotation()
        if let location = fromPlacemark.location {
            fromAnnotaion.coordinate = location.coordinate
        }
        //placemark for destination.
        let destinationPlacemark = MKPlacemark(coordinate: (self.path?.destination)!)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let destinationAnnotaiton = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotaiton.coordinate = location.coordinate
        }

        if path.stop != nil {
            //if route has a stop.
            self.path?.stop = path.stop
            let stopPlacemark = MKPlacemark(coordinate: (self.path?.stop)! )
            let stopMapItem = MKMapItem(placemark: stopPlacemark)
           
            //draw path though three points.
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = fromMapItem
            directionRequest.destination = stopMapItem
            directionRequest.transportType = .automobile
            directionRequest.requestsAlternateRoutes = false
            var fromToStopRoute = MKRoute()
            var stopToDestinationRoute = MKRoute()
            
            var directions = MKDirections(request: directionRequest)
            directions.calculate { [unowned self]
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                fromToStopRoute = response.routes[0]
                self.routes.append(fromToStopRoute)
                self.mapView.add((response.routes[0].polyline), level: MKOverlayLevel.aboveRoads)
            }
            
            directionRequest.source = stopMapItem
            directionRequest.destination = destinationMapItem
            directions = MKDirections(request: directionRequest)
            
            directions.calculate { [unowned self]
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                stopToDestinationRoute = response.routes[0]
                self.routes.append(stopToDestinationRoute)
                self.mapView.add((response.routes[0].polyline), level: MKOverlayLevel.aboveRoads)
            }
            
        } else {
            //if route does not have a stop.
            //draw path between two points.
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = fromMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .automobile
            directionRequest.requestsAlternateRoutes = false
            let directions = MKDirections(request: directionRequest)
            directions.calculate { [unowned self]
                (response, error) -> Void in
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                self.routes.append(response.routes[0])
                self.mapView.add((response.routes[0].polyline), level: MKOverlayLevel.aboveRoads)
                
            }
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
    
    //MARK: - UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let whereToViewController = storyboard.instantiateViewController(withIdentifier: "WhereToViewController") as? WhereToViewController else {
            fatalError("Failed to instantiate ViewController with identifier WhereToViewController. Check storyboard id.")
        }
        whereToViewController.currentMapRegion = mapView.region
        present(whereToViewController, animated: true, completion: nil)
    }

    private func removeRoute() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        path = nil
    }
    
    //MARK: - Create Route
    @IBAction func createRoute(sender: UIButton) {
        assert(path != nil, "Oops. Path is nil")
        
        let departureDate = timePicker.date
        
        //Create route
        let route = Route(driver: driver!, path: path!, time: departureDate, maxPlaces: 3, routes: routes)
        
        //Send POST reques to _/routes.
        RequestManager.shared.addRoute(route: route)
        
        navigationController?.popViewController(animated: true)
    }
}


