//
//  UofTAPI+Parking.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-17.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import Alamofire

extension UofTAPI {

    static func updateParkingDB() {
        makeParkingRequest(skip: 0)
    }

    static func makeParkingRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .parking, skip: skip, limit: limit)
    }

    static func makeParkingRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeParkingRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            print(response.result)
            print("==============")

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for parking in JSON {
                    addOrUpdateParking(fromJSON: parking)
                }
                makeParkingRequest(skip: skip + limit, limit: limit)
            }
        }
    }

    static func addOrUpdateParking(fromJSON json: [String:Any]) {
        guard
            let id = json["id"] as? String,
            let title = json["title"] as? String,
            let buildingID = json["building_id"] as? String,
            let campus = json["campus"] as? String,
            let type = json["type"] as? String,
            let parkingDescription = json["description"] as? String,
            let latitude = json["lat"] as? Double,
            let longitude = json["lng"] as? Double,
            let address = json["address"] as? String else {
                print("JSON does not conform to Parking Prototype JSON")
                return
        }

        let geoLocation = GeoLocation()
        geoLocation.latitude = latitude
        geoLocation.longitude = longitude

        let parkingLocation = ParkingLocation()
        parkingLocation.id = id
        parkingLocation.title = title
        parkingLocation.buildingID = buildingID
        parkingLocation.campus = campus
        parkingLocation.type = type
        parkingLocation.parkingDescription = parkingDescription
        parkingLocation.address = address

        try! realm.write {
            realm.add(parkingLocation, update: true)
        }
    }
}
