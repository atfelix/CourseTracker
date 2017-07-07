//
//  MapViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-15.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class MapViewController: UIViewController {
    
    //MARK: Properties

    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!

    var distance: Float = 0 {
        didSet {
            self.distanceLabel.alpha = 1.0
            self.distanceLabel.text = String(format: "Distance = %.0fm", distance)
        }
    }
    var currentOverlays: [MKOverlay?] = []
    var currentParkingPins: [MKPointAnnotation] = []
    var buildingArray: [MKPointAnnotation]!
    var width = 0

    var realm: Realm!
    var student: Student!
    var date: Date!
}
