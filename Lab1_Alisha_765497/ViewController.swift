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
    
    var driving = true
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let DTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        DTap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(DTap)
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 43.64, longitude: -79.38), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
        
       
    }
    
    
    
    @IBAction func driving(_ sender: UIButton) {
        
        
        driving = true
        let overlayALL = mapView.overlays
        if overlayALL.count > 0 {
            
            mapView.removeOverlays(overlayALL)
            
        }
        
        showDirection(destination: coordinate)
    }
    @IBAction func walking(_ sender: UIButton) {
        
        driving = false
        let overlayALL = mapView.overlays
        if overlayALL.count > 0 {
            
            mapView.removeOverlays(overlayALL)
            
        }
        showDirection(destination: coordinate)
        
    }
    @objc func doubleTap(gestureRecognizer: UIGestureRecognizer)
    {
        
        let overlayALL = mapView.overlays
        if overlayALL.count > 0 {
            
            mapView.removeOverlays(overlayALL)
            
        }
        
        let all = mapView.annotations
        
        if all.count == 2 {
            
            let a = all[1]
            mapView.removeAnnotation(a)
            
        }
        
        let point = gestureRecognizer.location(in: mapView)
        coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
 

    @IBAction func direction(_ sender: UIButton)
    {
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
        destinationRequest.transportType = driving ? MKDirectionsTransportType.automobile : MKDirectionsTransportType.walking
        
        let dire = MKDirections(request: destinationRequest)
        dire.calculate{(response, error) in
            guard let response = response
            else{
            if let error = error
            {
            print("there is an error")
            }
            return
            }
           
            let route = response.routes[0]
            print(route)
            self.mapView.addOverlay(route.polyline)
            print("okkkk")
            
    }
}
    
    
    @IBAction func ZoomIn(_ sender: UIButton) {
        var zoom = mapView.region
        zoom.span.latitudeDelta = zoom.span.latitudeDelta / 2
        zoom.span.longitudeDelta = zoom.span.longitudeDelta / 2
        mapView.setRegion(zoom, animated: true)
    }
    
    @IBAction func ZoomOut(_ sender: UIButton) {
        var zoom = mapView.region
               zoom.span.latitudeDelta = zoom.span.latitudeDelta * 2
               zoom.span.longitudeDelta = zoom.span.longitudeDelta * 2
               mapView.setRegion(zoom, animated: true)
    }
    
    // function to add overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
       {
        
        if overlay is MKPolyline{
            let rendrer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            rendrer.strokeColor = .blue
            rendrer.lineWidth = 5.0
            return rendrer
        }
        return MKOverlayRenderer()
        }
    
    
    
}



