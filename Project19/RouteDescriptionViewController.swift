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
    
    //private properties
    var mappoints = [MKMapPoint]()
    
    @IBAction func placeAnnotation(sender: UIButton) {
        placeProposedPickupLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let pointcount = route.path.route.polyline.pointCount
        let cllocationcoordinate2Dpointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointcount)
        let range = NSRange(location: 0, length: pointcount)
        print( route.path.route.polyline.getCoordinates(cllocationcoordinate2Dpointer, range: range))
        print(cllocationcoordinate2Dpointer)
        for i in 0..<pointcount {
            let mapPoint = MKMapPoint(x: cllocationcoordinate2Dpointer[i].latitude, y: cllocationcoordinate2Dpointer[i].longitude)
            mappoints.append(mapPoint)
//            show annotations on map
//            mapView.showAnnotations([mappointannotation], animated: true)
        }
        drawRouteOnMap()
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
    
    //        let polylineRenderer = MKPolylineRenderer(polyline: route.path.route.polyline)
    //        let pickupMapPoint = MKMapPointForCoordinate(pickupCoordinate)
    //        let point = polylineRenderer.point(for: pickupMapPoint)
    //        if polylineRenderer.path.contains(point) {
    //            print("on line")
    //        } else {
    //            print("off line")
    //        }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
    }
    
    // MARK: - Private methods
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
        
        pointsAndDistances.sort { (lhs: PointAndDistance, rhs: PointAndDistance) -> Bool in
            return lhs.distance < rhs.distance
        }
        //create CGPoints for line segment points
        let firstPointLocation = CLLocationCoordinate2D(latitude: pointsAndDistances[0].point.x, longitude: pointsAndDistances[0].point.y)
        let secondPointLocation = CLLocationCoordinate2D(latitude: pointsAndDistances[1].point.x, longitude: pointsAndDistances[1].point.y)
        //uncomment to show annotation for line segment points.
        //        //place annotaions for two closest points
        //        let closestPoint1 = MKPointAnnotation()
        //        closestPoint1.coordinate = firstPointLocation
        //        let clp1 = MKPlacemark(coordinate: firstPointLocation, addressDictionary: nil)
        //
        //        if let location = clp1.location {
        //            closestPoint1.coordinate = location.coordinate
        //        }
        //        let closestPoint2 = MKPointAnnotation()
        //        closestPoint2.coordinate = secondPointLocation
        //        let clp2 = MKPlacemark(coordinate: secondPointLocation, addressDictionary: nil)
        //
        //        if let location = clp2.location {
        //            closestPoint2.coordinate = location.coordinate
        //        }
        //
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
        //uncomment to show annotation for line segment points.
        //mapView.showAnnotations([closestPoint1, closestPoint2, proposedpickupAnnotation], animated: true)
        mapView.showAnnotations([proposedpickupAnnotation], animated: true)
    }

    private func drawRouteOnMap() {
        mapView.add((route.path.route.polyline), level: MKOverlayLevel.aboveRoads)
        let rect = route.path.route.polyline.boundingMapRect
        mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
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

struct PointAndDistance {
    var point: MKMapPoint
    var distance: CLLocationDistance
}
