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
        makeParkingRequest(skip: realm.objects(ParkingLocation.self).count)
    }

    static func makeParkingRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .parking, skip: skip, limit: limit)
    }

    static func makeParkingRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeParkingRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            logResponseInfo(response: response)

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for parking in JSON {
                    addOrUpdateParking(fromJSON: parking)
                }

                if JSON.count == limit {
                    sleep(5)
                    makeParkingRequest(skip: skip + limit, limit: limit)
                }
            }
        }
    }

    static func addOrUpdateParking(fromJSON json: [String:Any]) {
        guard let parkingLocation = ParkingLocation(fromJSON: json) else {
                print("JSON does not conform to Parking Prototype JSON")
                return
        }

        do {
            try realm.write {
                realm.add(parkingLocation, update: true)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }
}
