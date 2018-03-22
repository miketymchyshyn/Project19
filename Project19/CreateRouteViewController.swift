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
 

    
    private var path: Path?
    
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
    }
    
    
    @objc func cancelRouteCreation(){
        timePickerView.isHidden = true
        whereToView.isHidden = false
        //TODO: sensible comstraint change
        MVtoBottom.constant = 0
        removeRoute()
    }
    
        // MARK: - showRouteOnMap        
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
            //TODO: fix namig for start and end location
            
            self?.path = Path(startLocation: sourcePlacemark.coordinate, startLocationDescription: sourceMapItem.name!, endLocation: destinationPlacemark.coordinate, endLocationDescription: destinationMapItem.name! , route: route)
            
            self?.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self?.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func showRouteOnMap(to destinationCoordinate: CLLocationCoordinate2D){
        showRouteOnMap(pickupCoordinate: mapView.userLocation.coordinate, destinationCoordinate: destinationCoordinate)
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
    private func removeRoute(){
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        path = nil
    }
    
    //MARK: - Crate Route
    @IBAction func createRoute(sender: UIButton) {
        //TODO: find out how to format and send route info.
        //Package two MKPointAnnotations: start anntoation and end annotation
        //Package MKRoute with them.
        let mockDriver = Driver(driverID: "qwerty", driverName: "John Johnson", driverCarName: "Chevrolet")
        assert(path != nil, "Oops. Path is nil")
        //TODO: set up correct date.
        let mockRoute = Route(driver: mockDriver, path: path!, time: Date(), maxPlaces: 3)
        RequestManager.shared.addRoute(route: mockRoute)
        navigationController?.popViewController(animated: true)
    }
}

