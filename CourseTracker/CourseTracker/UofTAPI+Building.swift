//
//  UofTAPI+Building.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-17.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import Alamofire

extension UofTAPI {

    static func updateBuildingDB() {
        makeBuildingRequest(skip: realm.objects(Building.self).count)
    }

    static func makeBuildingsRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .buildings, skip: skip, limit: limit)
    }

    static func makeBuildingRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeBuildingsRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            logResponseInfo(response: response)

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for building in JSON {
                    addOrUpdateBuilding(fromJSON: building)
                }

                if JSON.count == limit {
                    sleep(5)
                    makeBuildingRequest(skip: skip + limit, limit: limit)
                }
            }
        }
    }

    static func addOrUpdateBuilding(fromJSON json: [String: Any]) {
        guard
            let id = json["id"] as? String,
            let code = json["code"] as? String,
            let name = json["name"] as? String,
            let shortName = json["short_name"] as? String,
            let campus = json["campus"] as? String,
            let latitude = json["lat"] as? Double,
            let longitude = json["lng"] as? Double,
            let polygonArray = json["polygon"] as? [[Double]],
            let addressJSON = json["address"] as? [String: String] else {
                print("JSON does not conform to Building Prototype JSON")
                return
        }

        let geoLocation = GeoLocation()
        geoLocation.latitude = latitude
        geoLocation.longitude = longitude

        let building = Building()
        building.id = id
        building.code = code
        building.name = name
        building.shortName = shortName
        building.campus = campus
        building.geoLocation = geoLocation

        let address = addOrUpdateAddress(fromJSON: addressJSON)
        building.address = address

        for location in polygonArray {
            guard location.count == 2 else {
                print("location is not 2 points")
                continue
            }
            let geoLocation = GeoLocation()
            geoLocation.latitude = location[0]
            geoLocation.longitude = location[1]
            building.polygon.append(geoLocation)
        }

        do {
            try realm.write {
                realm.add(building, update: true)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }

    @discardableResult static func addOrUpdateAddress(fromJSON json: [String:String]) -> Address? {
        guard let address = Address(fromJSON: json) else {
            print("JSON does not conform to Address Prototype JSON")
            return nil
        }

        do {
            try realm.write {
                realm.add(address, update: true)
            }
            return address
        }
        catch let error {
            UofTAPI.logRealmError(error)
            return nil
        }
    }
}
