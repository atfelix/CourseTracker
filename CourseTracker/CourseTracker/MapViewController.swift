//
//  MapViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-15.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

// Google maps API KEY: "AIzaSyD3pj2NAcnXZxxKoOtdNeg6L-8bjDKdIRc"


import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    //MARK: Properties
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    var myLocation:CLLocationCoordinate2D?
    //set location tracking
    let locationManager = CLLocationManager()
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        //if location is enabled
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true //zoom
        mapView.isScrollEnabled = true //scroll
        
        if let coor = mapView.userLocation.location?.coordinate{
            mapView.setCenter(coor, animated: true)
        }
        addLongPressGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapView.showsUserLocation = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.showsUserLocation = false
    }
    
    //MARK: Helper methods
    //gesture to add pins
    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0 //user needs to press for 2 seconds
        self.mapView.addGestureRecognizer(longPressRecogniser)
    }
    //add pin to tapped area
    func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .began{
            return
        }
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.mapView)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        
        self.resetTracking()
        self.mapView.addAnnotation(annot)
        self.centerMap(touchMapCoordinate)
    }
    //reset the users location
    func resetTracking(){
        if (mapView.showsUserLocation){
            mapView.showsUserLocation = false
            self.mapView.removeAnnotations(mapView.annotations)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    //centers the map
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        //axis
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        mapView.setRegion(newRegion, animated: true)
    }
    //MARK: CLLocationManager
    //save the location
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        self.locationLabel.text = message
        myLocation = center
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        //center map on to new location
        centerMap(locValue)
    }
    
    static var enable:Bool = true
    
    //set button to get current location
    @IBAction func getMyLocation(_ sender: UIButton) {
        
        if CLLocationManager.locationServicesEnabled() {
            if MapViewController.enable {
                locationManager.stopUpdatingHeading()
                sender.titleLabel?.text = "Enable"
            }else{
                locationManager.startUpdatingLocation()
                sender.titleLabel?.text = "Disable"
            }
            MapViewController.enable = !MapViewController.enable
        }
    }
    
    //MARK: MapView Delegate
    //set pin annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "pin"
        var view : MKPinAnnotationView
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
            dequeueView.annotation = annotation
            view = dequeueView
        }else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        view.pinTintColor =  .red
        return view
    }
    
}
