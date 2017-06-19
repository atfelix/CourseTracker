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

    static func updateBuildingsDB() {
        makeBuildingRequest(skip: realm.objects(Building.self).count)
    }

    static func makeBuildingsRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .buildings, skip: skip, limit: limit)
    }

    static func makeBuildingRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeBuildingsRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            print(response.result)
            print("================")

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for building in JSON {
                    addOrUpdateBuilding(fromJSON: building)
                }
                makeBuildingRequest(skip: skip + limit, limit: limit)
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

        let address = Address()
        addOrUpdateAddress(address: address, fromJSON: addressJSON)
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

        try! realm.write {
            realm.add(building, update: true)
        }
    }

    static func addOrUpdateAddress(address: Address, fromJSON json: [String:String]) {
        guard
            let street = json["street"],
            let city = json["city"],
            let province = json["province"],
            let country = json["country"],
            let postalCode = json["postal"] else {
                print("JSON does not conform to Address Prototype JSON")
                return
        }

        address.street = street
        address.city = city
        address.province = province
        address.country = country
        address.postalCode = postalCode
        address.id = [street, city, province, country, postalCode].joined(separator: ", ")

        try! realm.write {
            realm.add(address, update: true)
        }
    }


}
