//
//  MapViewController+ViewLifeCycle.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import MapKit

extension MapViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
        setupBuildingData()
    }

    private func setupMapView() {
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        distanceLabel.text = ""
    }

    private func setupBuildingData() {
        buildingArray = getBuildingInfo()

        mapView.addAnnotations(buildingArray)
        self.width = buildingArray.count - 1

        addAllDirections()
        centerLocationAroundRoute()
    }

    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func locationButtonTapped(_ sender: Any) {
        struct Type {
            static var type = 0
        }

        mapView.removeAnnotations(currentParkingPins)
        currentParkingPins.removeAll()
        Type.type = (Type.type + 1) % 3
        addParkingLocations(type: Type.type)
    }
}
