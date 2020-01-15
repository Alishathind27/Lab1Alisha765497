//
//  ViewController.swift
//  Lab1_Alisha_765497
//
//  Created by Alisha Thind on 2020-01-14.
//  Copyright © 2020 Alisha Thind. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
 
    @IBOutlet weak var directionButton: UIButton!
    var desti: MKMapItem?
    var locationManager = CLLocationManager()
    var coordinate: CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let DTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        DTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(DTap)
    
       
    }
    
    @objc func doubleTap(gestureRecognizer: UIGestureRecognizer)
    {
        
        let point = gestureRecognizer.location(in: mapView)
        coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

    }
 

    @IBAction func direction(_ sender: UIButton) {
        
        showDirection(destination: coordinate)
    }
    
    
    func showDirection(destination: CLLocationCoordinate2D)
    {
        let SCoordinate = mapView.annotations[0].coordinate
        let DCoordinate = mapView.annotations[1].coordinate
        
        let SMark = MKPlacemark(coordinate: SCoordinate)
        let DMark = MKPlacemark(coordinate: DCoordinate)
        
        let SItem = MKMapItem(placemark: SMark)
        let DItem = MKMapItem(placemark: DMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = SItem
        destinationRequest.destination = DItem
        destinationRequest.transportType = .automobile
        
        let dire = MKDirections(request: destinationRequest)
        dire.calculate{(response, error) in
        guard let response = response else{
            if let error = error {
                print("dhhsbd")
            }
            return
            }
           
            let route = response.routes[0]
            print(route)
            self.mapView.addOverlay(route.polyline)
            print("hxbs")
    }
        
}
    
    // function to add overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline{
            let rendrer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            rendrer.strokeColor = .blue
            rendrer.lineWidth = 5.0
            return rendrer
        }
        return MKOverlayRenderer()
        }
    }


