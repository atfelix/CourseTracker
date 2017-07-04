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
            let addressJSON = json["address"] as? [String:String],
            let address = addOrUpdateAddress(fromJSON: addressJSON),
            let building = Building(fromJSON: json, address: address) else {
                print("JSON does not conform to Building Prototype JSON")
                return
        }

        building.address = address

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
