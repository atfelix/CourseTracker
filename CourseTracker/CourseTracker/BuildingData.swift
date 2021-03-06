//
//  BuildingData.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-18.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import MapKit

class BuildingData: NSObject, MKAnnotation {

    var name: String?
    var address: String?
    var latitude: Double
    var longitude: Double

    var title: String? {
        get {
            return name
        }
    }
    
    var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
}
