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
    @IBOutlet weak var distanceLabel: UILabel!
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
        //adds annotation to the map
        addLongPressGesture()
        //adds polylines from source to destination and prints distance
        setupRouteInfo()
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
    //set up the routes
    func setupRouteInfo(){
        let sourceLocation = CLLocationCoordinate2D(latitude: 43.66, longitude: -79.39)
        let destinationLocation = CLLocationCoordinate2D(latitude: 51.22, longitude: -85.33)
        //set data for source
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "title 1"
        sourceAnnotation.coordinate = sourceLocation
        //set data for destination
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "title 2"
        destinationAnnotation.coordinate = destinationLocation
        //put annotation on map
        mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        //placemark
        let sourcePM = MKPlacemark(coordinate: sourceLocation)
        let destinationPM = MKPlacemark(coordinate: destinationLocation)
        //map items
        let sourceMapItem = MKMapItem(placemark: sourcePM)
        let destinationMapItem = MKMapItem(placemark: destinationPM)
        
        //map the coords
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            if error != nil{
                print(error ?? "")
                return
            }//draw the line
            if let response = response{
                let route = response.routes[0]
                //draw the polyline
                self.mapView.add(route.polyline, level: .aboveRoads)
                let distance = route.distance / 1000  //sets the distance
                let result = String(format: "%.1f", distance)  //to 1 decimal
                //set distance label
                self.distanceLabel.text = "Distance = \(result) KM"
                let routeRect = route.polyline.boundingMapRect //bounds of the line
                self.mapView.setRegion(MKCoordinateRegionForMapRect(routeRect), animated: true)
                
            }
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
    //sets the line for the route path
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.lineWidth = 4.0
        render.strokeColor = UIColor.blue
        return render
    }
    
}
