//
//  MapViewController+Utility.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import MapKit
import JTAppleCalendar

extension MapViewController {
    func addParkingLocations(type: Int) {
        let stringType = ["asdf", "car", "bicycle"][type]
        let parkingLocations = realm.objects(ParkingLocation.self).filter("type == '\(stringType)'")

        for location in parkingLocations {
            addParkingLocation(location: location)
        }
    }

    func addParkingLocation(location: ParkingLocation) {
        guard
            let latitude = location.geoLocation?.latitude,
            let longitude = location.geoLocation?.longitude else {
                return
        }

        let point = MKPointAnnotation()
        point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        point.title = location.parkingDescription
        point.subtitle = "Type: \(location.type)"

        mapView.addAnnotation(point)
        currentParkingPins.append(point)
    }

    func centerLocationAroundRoute() {
        if let maxLatitude = buildingArray.map({ $0.coordinate.latitude }).max(),
            let minLatitude = buildingArray.map({ $0.coordinate.latitude }).min(),
            let maxLongitude = buildingArray.map({ $0.coordinate.longitude }).max(),
            let minLongitude = buildingArray.map({ $0.coordinate.longitude }).min() {

            let centerPoint = CLLocationCoordinate2D(latitude: (minLatitude + maxLatitude) / 2, longitude: (minLongitude + maxLongitude) / 2)
            let latitudinalMeters = CLLocation(latitude: minLatitude, longitude: minLongitude).distance(from: CLLocation(latitude: maxLatitude, longitude: minLongitude))
            let longitudinalMeters = CLLocation(latitude: minLatitude, longitude: minLongitude).distance(from: CLLocation(latitude: minLatitude, longitude: maxLongitude))
            let region = MKCoordinateRegionMakeWithDistance(centerPoint, 3 * max(100, latitudinalMeters), 3 * max(100, longitudinalMeters))
            mapView.setRegion(region, animated: true)
        }
    }

    func addAllDirections() {
        for i in stride(from: buildingArray.count - 2, through: 0, by: -1) {
            addDirections(between: buildingArray[i + 1], and: buildingArray[i])
        }
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

            if
                let welf = self,
                let route = response.routes.first {
                welf.mapView.addOverlays([route.polyline], level: .aboveRoads)
            }
        }
    }

    func getBuildingInfo() -> [MKPointAnnotation] {
        var buildings = [MKPointAnnotation]()

        guard let day = DaysOfWeek(rawValue: Calendar.current.component(.weekday, from: date)) else { return buildings }

        for course in student.coursesFor(day: day) {
            addBuildingAnnotationView(for: day, from: course, to: &buildings)
        }
        return buildings
    }

    func addBuildingAnnotationView(for day: JTAppleCalendar.DaysOfWeek, from course: Course, to buildings: inout [MKPointAnnotation]) {
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
        }
    }

    func distance(between source: MKPointAnnotation, and destination: MKPointAnnotation) -> Float {
        let x = CLLocation(latitude: source.coordinate.latitude, longitude: source.coordinate.longitude)
        let y = CLLocation(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude)
        return Float(x.distance(from: y))
    }
}
