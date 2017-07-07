//
//  MapViewController+MapViewDelegate.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView()

        if let subtitle = annotation.subtitle {
            switch subtitle {
            case "Type: bicycle"?: pin.pinTintColor = .green
            case "Type: car"?: pin.pinTintColor = .blue
            default: pin.pinTintColor = .red
            }
        }
        pin.canShowCallout = true
        return pin
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)

        if overlay is MKPolyline {
            currentOverlays.append(overlay)
            render.strokeColor = [UIColor.blue, UIColor.red, UIColor.black, UIColor.green, UIColor.brown][self.width % 5]
            render.lineWidth = CGFloat(2 * self.width + 2)
            self.width = max(0, width - 1)
        }
        return render
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        mapView.removeOverlays(currentOverlays as! [MKOverlay])
        currentOverlays.removeAll()

        guard
            let view = view as? MKPinAnnotationView,
            let annotation = view.annotation as? MKPointAnnotation,
            let index = buildingArray.index(of: annotation),
            buildingArray.count > 1 else {
                return
        }

        let (a, b) = (index == buildingArray.count - 1) ? (-1, 0) : (0, 1)
        let source = buildingArray[index + a]
        let destination = buildingArray[index + b]

        addDirections(between: source, and: destination)
        self.distance = distance(between: source, and: destination)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        mapView.removeOverlays(currentOverlays as! [MKOverlay])
        currentOverlays.removeAll()
    }
}
