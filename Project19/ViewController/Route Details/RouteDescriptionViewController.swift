//
//  RouteDescriptionViewController.swift
//  Project19
//
//  Created by Mykhailo Tymchyshyn on 3/14/18.
//  Copyright © 2018 Mykhailo Tymchyshyn. All rights reserved.
//

import UIKit
import MapKit

class RouteDescriptionViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var route: Route!
    //Little white square in a middle of map view. 
    @IBOutlet weak var centerView: UIView!
    
    private var mappoints = [MKMapPoint]()
    

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initMappoints()
        drawRouteOnMap()
        placeMarkerForStartLocation()
    }
    
    @IBAction func placeAnnotation(sender: UIButton) {
        placeProposedPickupLocation()
    }
    
    @IBAction func handleSwipeToSeePassengers(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "SegueToPassengersTable", sender: self)
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
    
    // MARK: - Private methods
    //proposed pick up location does its calculations based on mappoints retrieved form MKRoute object
    private func placeProposedPickupLocation() {
        mapView.removeAnnotations(mapView.annotations)
        let pickupCoordinate = CLLocationCoordinate2D(latitude: mapView.convert(mapView.center, toCoordinateFrom: mapView).latitude, longitude: mapView.convert(mapView.center, toCoordinateFrom: mapView).longitude)
        let pickupMapPoint = MKMapPoint(x: pickupCoordinate.latitude, y: pickupCoordinate.longitude)
        
        var pointsAndDistances = [PointAndDistance]()
        for point in mappoints {
            //distance between pickup coordinate and point on route polyline
            let distance = MKMetersBetweenMapPoints(point, pickupMapPoint);
            pointsAndDistances.append(PointAndDistance(point: point, distance: distance))
        }
        
        pointsAndDistances.sort { $0.distance < $1.distance }
        //create CGPoints for line segment points
        let firstPointLocation = CLLocationCoordinate2D(latitude: pointsAndDistances[0].point.x, longitude: pointsAndDistances[0].point.y)
        let secondPointLocation = CLLocationCoordinate2D(latitude: pointsAndDistances[1].point.x, longitude: pointsAndDistances[1].point.y)

        //CGPoints for line segment coordinates
        let firstPoint = mapView.convert(firstPointLocation, toPointTo: nil)
        let secondPoint = mapView.convert(secondPointLocation, toPointTo: nil)
        
        //CGPoint for pickup point
        let desiredPickupPoint = mapView.convert(pickupCoordinate, toPointTo: nil)
        let proposedPickupPoint = desiredPickupPoint.closestPointOnLineSegment(start: firstPoint, end: secondPoint)
        
        let proposedPickupCoordinate = mapView.convert(proposedPickupPoint, toCoordinateFrom: nil)
        
        //place annotation for proposed pickup point
        let proposedpickupAnnotation = MKPointAnnotation()
        let pickupPlacemark = MKPlacemark(coordinate: proposedPickupCoordinate, addressDictionary: nil)
        if let location = pickupPlacemark.location {
            proposedpickupAnnotation.coordinate = location.coordinate
        }
        
        mapView.showAnnotations([proposedpickupAnnotation], animated: true)
    }
    
    private func placeMarkerForStartLocation() {
        assert(route.path.from != nil)
        let startLocation = route.path.from
        let annotation = RouteAnnotation(coordinate: startLocation!, title: "Start")
        mapView.addAnnotation(annotation)
    }
    
    private func initMappoints() {
        for route in route.routes {
            let pointcount = route.polyline.pointCount
            let cllocationcoordinate2Dpointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointcount)
            let range = NSRange(location: 0, length: pointcount)
            print( route.polyline.getCoordinates(cllocationcoordinate2Dpointer, range: range))
            print(cllocationcoordinate2Dpointer)
            for i in 0..<pointcount {
                let mapPoint = MKMapPoint(x: cllocationcoordinate2Dpointer[i].latitude, y: cllocationcoordinate2Dpointer[i].longitude)
                mappoints.append(mapPoint)
            }
        }
    }
    
    private func drawRouteOnMap() {
        for route in route.routes {
            mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
}

extension CGPoint {
    func closestPointOnLineSegment(start p1: CGPoint, end p2: CGPoint) -> CGPoint {
        let v = CGPoint(x: p2.x - p1.x,y: p2.y - p1.y)
        var t: CGFloat = (self.x * v.x - p1.x * v.x + self.y * v.y - p1.y * v.y) / (v.x * v.x + v.y * v.y)
        if t < 0 { t = 0 }
        else if t > 1 { t = 1 }
        return CGPoint(x: p1.x + t * v.x, y: p1.y + t * v.y)
    }
}

class RouteAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String){
        self.coordinate = coordinate
        self.title = title
    }
}

struct PointAndDistance {
    var point: MKMapPoint
    var distance: CLLocationDistance
}
