//
//  MapViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-15.
//  Copyright © 2017 Adam Felix. All rights reserved.
//



import UIKit
import MapKit
import CoreLocation
import RealmSwift
import JTAppleCalendar

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    //MARK: Properties
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    //core location
    var locationManager = CLLocationManager()
    //print labels in middle of map
    var middlePoint: MKMapPoint!
    var time: Int = 0
    var distance: Float = 0
    
    //realm
    var realm: Realm!
    var student: Student!
    var date: Date!
    
        //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Map View
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true //zoom
        mapView.isScrollEnabled = true //scroll
        
        //Set Core Location
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // You can change the locaiton accuary here.
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        let buildingArray = getBuildingInfo()
        //add buildings to the map

        mapView.addAnnotations(buildingArray)
        mapView.selectAnnotation(buildingArray[0], animated: false)

        if let maxLatitude = buildingArray.map({ $0.coordinate.latitude }).max(),
            let minLatitude = buildingArray.map({ $0.coordinate.latitude }).min(),
            let maxLongitude = buildingArray.map({ $0.coordinate.longitude }).max(),
            let minLongitude = buildingArray.map({ $0.coordinate.longitude }).min() {

            let centerPoint = CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2, longitude: (minLongitude + maxLongitude) / 2)
            let latitudinalMeters = CLLocation(latitude: minLatitude, longitude: minLongitude).distance(from: CLLocation(latitude: maxLatitude, longitude: minLongitude))
            let longitudinalMeters = CLLocation(latitude: minLatitude, longitude: minLongitude).distance(from: CLLocation(latitude: minLatitude, longitude: maxLongitude))
            let region = MKCoordinateRegionMakeWithDistance(centerPoint, 1.8 * latitudinalMeters, 1.8 * longitudinalMeters)
            mapView.setRegion(region, animated: true)
        }


        
        //connect all the events using poly line
        var points : [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for annotation in buildingArray{
            points.append(annotation.coordinate) //append the points
        }
        
        let polyline = MKPolyline(coordinates: &points, count: points.count)
        //add the poly line to the map
        mapView.add(polyline)
        
    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        //Set Core Location
    //        startLocationUpdates()
    //    }
    
    //MARK: Helper methods
    
    //    func getDirections(){
    //        if let selectedPin = selectedPin {
    //            let mapItem = MKMapItem(placemark: selectedPin)
    //            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
    //            mapItem.openInMapsWithLaunchOptions(launchOptions)
    //        }
    //    }
    
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
    
    func getBuildingInfo() -> [MKPointAnnotation] {
        let myLocation = CLLocation(latitude: 43.66, longitude:-79.39)
        var buildings = [MKPointAnnotation]()
        let day = DaysOfWeek(rawValue: Calendar.current.component(.weekday, from: date))!
        
        //MARK: this might mess shit up
        for course in student.coursesFor(day: day) {
            
            if let time = course.courseTimeFor(day: day).first,
                let building = time.building,
                let latitude = building.geoLocation?.latitude,
                let longitude = building.geoLocation?.longitude {

                let annotationView = MKPointAnnotation()
                annotationView.coordinate.latitude = latitude
                annotationView.coordinate.longitude = longitude
                annotationView.title = building.name

                
//                let annotation = BuildingData(latitude: latitude, longitude: longitude)
//                annotation.name = building.name
//                annotation.address = building.address?.street
//                annotationView.annotation = annotation

                buildings.append(annotationView)
                
                let distance = myLocation.distance(from: CLLocation(latitude: latitude, longitude: longitude))
                let result = String(format: "%.1f", distance / 1000)
                self.distanceLabel.text = "Distance = \(result) KM"
            }
        }
        
        return buildings
    }
    
    //print the routes to the map
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
                //set the name of the annotation
                annotation.name = (item as AnyObject).value(forKey: "name") as? String
                //append the building array with annotation items
                buildingArray.append(annotation)
                
                //set the distance label to current distance
                let distance = myLocation.distance(from: CLLocation(latitude: lat, longitude: long))
                let result = String(format: "%.1f", distance/1000)
                self.distanceLabel.text = "Distance = \(result) KM" //add time to get to route
                
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
            render.lineWidth = 1.0
        }
        return render
    }
    
    //MARK: Core Location
    
    //    func startLocationUpdates(){
    //        locationManager = CLLocationManager()
    //        locationManager.delegate = self
    //        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    //        locationManager.requestAlwaysAuthorization()
    //
    //        if CLLocationManager.locationServicesEnabled() {
    //            locationManager.startUpdatingLocation()
    //            locationManager.startUpdatingHeading()
    //        }
    //    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let lat = userLocation.coordinate.latitude
        let lon = userLocation.coordinate.longitude
        
        print("You are at \(lat), \(lon)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error determining location: \(error)")
    }
}
