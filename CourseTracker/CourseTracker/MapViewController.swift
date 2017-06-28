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
    var distance: Float = 0 {
        didSet {
            self.distanceLabel.alpha = 1.0
            self.distanceLabel.text = String(format: "Distance = %.0fm", distance)
        }
    }
    var currentOverlays: [MKOverlay?] = []
    var buildingArray: [MKPointAnnotation]!
    var width = 0
    
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

        //add buildings to the map

        buildingArray = getBuildingInfo()

        mapView.addAnnotations(buildingArray)
        self.width = buildingArray.count - 1

        mapView.selectAnnotation(buildingArray[0], animated: true)

        for i in stride(from: buildingArray.count - 2, through: 0, by: -1) {
            addDirections(between: buildingArray[i + 1], and: buildingArray[i])
        }

        if let maxLatitude = buildingArray.map({ $0.coordinate.latitude }).max(),
            let minLatitude = buildingArray.map({ $0.coordinate.latitude }).min(),
            let maxLongitude = buildingArray.map({ $0.coordinate.longitude }).max(),
            let minLongitude = buildingArray.map({ $0.coordinate.longitude }).min() {

            let centerPoint = CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2, longitude: (minLongitude + maxLongitude) / 2)
            let latitudinalMeters = CLLocation(latitude: minLatitude, longitude: minLongitude).distance(from: CLLocation(latitude: maxLatitude, longitude: minLongitude))
            let longitudinalMeters = CLLocation(latitude: minLatitude, longitude: minLongitude).distance(from: CLLocation(latitude: minLatitude, longitude: maxLongitude))
            let region = MKCoordinateRegionMakeWithDistance(centerPoint, 3 * latitudinalMeters, 3 * longitudinalMeters)
            mapView.setRegion(region, animated: true)
        }


        
        //connect all the events using poly line
        var points = [CLLocationCoordinate2D]()
        
        for annotation in buildingArray {
            points.append(annotation.coordinate) //append the points
        }

        distanceLabel.text = ""
        
        //let polyline = MKPolyline(coordinates: &points, count: points.count)
//        add the poly line to the map
        //mapView.add(polyline)
        
    }

    func addDirections(between source: MKPointAnnotation, and destination: MKPointAnnotation) {
        let sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: source.coordinate, addressDictionary: nil))
        let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination.coordinate, addressDictionary: nil))
        let directionsRequest = MKDirectionsRequest()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destinationMapItem
        directionsRequest.transportType = .walking
        let directions = MKDirections(request: directionsRequest)

        directions.calculate { [weak self]
            (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                return
            }

            if let welf = self,
                let route = response.routes.first {
                welf.mapView.addOverlays([route.polyline], level: .aboveRoads)
                print(route.polyline.boundingMapRect.origin)
                print(sourceMapItem)
            }
        }
    }
    
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

        for course in student.coursesFor(day: day) {
            
            if let time = course.courseTimeFor(day: day).first,
                let building = time.building,
                let latitude = building.geoLocation?.latitude,
                let longitude = building.geoLocation?.longitude {

                let annotationView = MKPointAnnotation()
                annotationView.coordinate.latitude = latitude
                annotationView.coordinate.longitude = longitude
                annotationView.title = course.code + ":  " + time.location
                annotationView.subtitle = time.startTime.convertSecondsFromMidnight() + "-" + time.endTime.convertSecondsFromMidnight()

                buildings.append(annotationView)
                
                let distance = myLocation.distance(from: CLLocation(latitude: latitude, longitude: longitude))
                let result = String(format: "%.1f", distance / 1000)
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
                self.distanceLabel.text = "" //add time to get to route
                
            }
        }
        return buildingArray
    }
    
    //MARK: MapView Delegate
    
    //sets the line for the route path
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        //if there is a line make it blue and wide
        if overlay is MKPolyline {
            currentOverlays.append(overlay)
            render.strokeColor = [UIColor.blue, UIColor.red, UIColor.black, UIColor.green, UIColor.brown][self.width % 5]
            render.lineWidth = CGFloat(2 * self.width + 2)
            self.width = max(0, width - 1)
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

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        mapView.removeOverlays(currentOverlays as! [MKOverlay])
        currentOverlays.removeAll()

        guard
            let view = view as? MKPinAnnotationView,
            let annotation = view.annotation as? MKPointAnnotation,
            let index = buildingArray.index(of: annotation) else {
                return
        }
        if index == buildingArray.count - 1 {
            addDirections(between: buildingArray[index - 1], and: buildingArray[index])
            let x = CLLocation(latitude: buildingArray[index - 1].coordinate.latitude, longitude: buildingArray[index - 1].coordinate.longitude)
            let y = CLLocation(latitude: buildingArray[index].coordinate.latitude, longitude: buildingArray[index].coordinate.longitude)
            self.distance = Float(x.distance(from: y))
        }
        else {
            addDirections(between: buildingArray[index], and: buildingArray[index + 1])
            let x = CLLocation(latitude: buildingArray[index].coordinate.latitude, longitude: buildingArray[index].coordinate.longitude)
            let y = CLLocation(latitude: buildingArray[index + 1].coordinate.latitude, longitude: buildingArray[index + 1].coordinate.longitude)
            self.distance = Float(x.distance(from: y))

        }
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        mapView.removeOverlays(currentOverlays as! [MKOverlay])
        currentOverlays.removeAll()
    }
}
