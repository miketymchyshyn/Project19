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
    
    /*
    ///deprecated
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { [weak self]
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            
            //store current route
            
            self?.path = Path(startLocation: sourcePlacemark.coordinate, startLocationDescription: sourceMapItem.name!, endLocation: destinationPlacemark.coordinate, endLocationDescription: destinationMapItem.name! , route: route)
            
            self?.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self?.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    ///deprecated
    func showRouteOnMap(to destinationCoordinate: CLLocationCoordinate2D){
        showRouteOnMap(pickupCoordinate: mapView.userLocation.coordinate, destinationCoordinate: destinationCoordinate)
    }
     */
    
    func showRouteOnMap(path: Path) {
        //        TODO: make map focus on created route.
        self.path = path
        if path.from == nil {
            self.path?.from = mapView.userLocation.coordinate
            self.path?.fromLocationDescription = mapView.userLocation.title
        }
        
        let fromPlacemark = MKPlacemark(coordinate: (self.path?.from)!)
        let fromMapItem = MKMapItem(placemark: fromPlacemark)
        let fromAnnotaion = MKPointAnnotation()
        if let location = fromPlacemark.location {
            fromAnnotaion.coordinate = location.coordinate
        }
        let destinationPlacemark = MKPlacemark(coordinate: (self.path?.destination)!)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        let destinationAnnotaiton = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotaiton.coordinate = location.coordinate
        }
        
        if path.stop != nil {
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
            //TODO: figure out how to make multiple(two) routes into one. Or do another way by handling [MKRoute]
            
        } else {
            //TODO: draw path between two points.
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
            fatalError("messed up storyboard.")
        }
        whereToViewController.currentMapRegion = mapView.region
        present(whereToViewController, animated: true, completion: nil)
    }

    //MARK: - Private funcs
    private func removeRoute() {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        path = nil
    }
    
    //MARK: - Create Route
    @IBAction func createRoute(sender: UIButton) {
        //TODO: find out how to format and send route info.
        //Package two or three MKPointAnnotations: start anntoation and end annotation, optional stopAnnotaion.
        //Package MKRoute with them.
        
        let mockDriver = Driver(driverName: "John Johnson", driverCarName: "Chevrolet")
        assert(path != nil, "Oops. Path is nil")
//        assert(route != nil, "Damn. Route is nil")
        //TODO: set up correct date.
        
        let mockRoute = Route(driver: mockDriver, path: path!, time: Date(), maxPlaces: 3, routes: routes)
        
        RequestManager.shared.addRoute(route: mockRoute)
        navigationController?.popViewController(animated: true)
    }
}


