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
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!

    var locationManager: CLLocationManager!
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set Map View-------------
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true //zoom
        mapView.isScrollEnabled = true //scroll
        
        centerMapAroundUserLocation(animated: true)
        
        let buildingArray = getRouteInfo()
        //add buildings to the map
        mapView.addAnnotations(buildingArray)
        
        //connect all the events using poly line
        var points : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for annotation in buildingArray{
            points.append(annotation.coordinate) //append the points
        }
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        //add the poly line to the map
        mapView.add(polyline)

    }
    //MARK: Helper methods
    
    //return to calendar
    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //center
    @IBAction func locationButtonTapped(_ sender: Any) {
        centerMapAroundUserLocation(animated: true)
    }
    
    //center map around user
    func centerMapAroundUserLocation(animated: Bool) {
        let location = CLLocationCoordinate2D(latitude: 43.66, longitude: -79.39)
        let region = MKCoordinateRegionMakeWithDistance(location, 500.0, 1000.0)
        //set to region
        
        mapView.setRegion(region, animated: true)
    }

    func getRouteInfo() -> [BuildingData]{
        
        let myLocation = CLLocation(latitude: 43.66, longitude: -79.39)
        
        var buildingArray: Array = [BuildingData]()
        //get the array of building data
        var buildings: NSArray?
        if let path = Bundle.main.path(forResource: "buildings", ofType: "plist"){
            buildings = NSArray(contentsOfFile: path)
        }
        if let items = buildings{
            for item in items{
                let lat = (item as AnyObject).value(forKey: "latitude") as! Double
                let long = (item as AnyObject).value(forKey: "longitude") as! Double
                //initialize the buildings
                let annotation = BuildingData(latitude: lat, longitude: long)
                annotation.name = (item as AnyObject).value(forKey: "name") as? String
                //append the building array with annotation items
                buildingArray.append(annotation)
                
                
                let distance = myLocation.distance(from: CLLocation(latitude: lat, longitude: long))
                let result = String(format: "%.1f", distance/1000)
                self.distanceLabel.text = "Distance = \(result) KM"
                
                
    
                
            }
        }
        return buildingArray
    }
    //MARK: MapView Delegate
    
    //sets the line for the route path
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        //if there is a line make it blue and wide
        if overlay is MKPolyline{
            render.strokeColor = UIColor.blue
            render.lineWidth = 5.0
        }
        return render
    }
    
}
