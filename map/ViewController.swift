//
//  ViewController.swift
//  map
//
//  Created by Ryan on 2018-10-12.
//  Copyright © 2018 Ryan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var lat = 1.00
    var long = 1.00
    
    var lastLat = 1.00
    var lastLong = 1.00
    var currentLat = 1.00
    var currentLong = 1.00
    
    var mapped = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // set initial location in Honolulu
    
        mapView.mapType = MKMapType.standard
        
        var currentLocation: CLLocation!
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        

    }
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        lat = locValue.latitude
        long = locValue.longitude
        if(lastLat == 1.00 && lastLong == 1.00) {
            lastLat = lat
            lastLong = long
            maplocation()
        }
        if(distance(lat1: lastLat, lon1: lastLong, lat2: lat, lon2: long, unit: "K") >= 10) {
            lastLat = lat
            lastLong = long
            print("fuck you")
            maplocation()
        }
        
    }
    
    func maplocation() {
            mapView.showsUserLocation = true
            let initialLocation = CLLocation(latitude: lat, longitude: long)
            //centerMapOnLocation(location: initialLocation)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            mapView.addAnnotation(annotation)
            mapView.layoutMargins = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    func deg2rad(deg:Double) -> Double {
        return deg * M_PI / 180
    }

    func rad2deg(rad:Double) -> Double {
        return rad * 180.0 / M_PI
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        if (unit == "K") {
            dist = dist * 1.609344
        }
        else if (unit == "N") {
            dist = dist * 0.8684
        }
        print(dist*1000)
        return (dist*1000)
    }
    
}

