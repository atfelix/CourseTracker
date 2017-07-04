//
//  UofTAPI+Athletics.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-17.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import Alamofire

extension UofTAPI {

    static func updateAthleticDB() {
        makeAthleticsRequest(skip: 0)
    }

    static func makeAthleticsRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .athletics, skip: skip, limit: limit)
    }

    static func makeAthleticsRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeAthleticsRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            logResponseInfo(response: response)

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for athleticDate in JSON {
                    addOrUpdateAthleticDate(fromJSON: athleticDate)
                }
                if JSON.count == limit {
                    sleep(5)
                    makeAthleticsRequest(skip: skip + limit, limit: limit)
                }
            }
        }
    }

    static func addOrUpdateAthleticDate(fromJSON json: [String:Any]) {
        guard
            let date = json["date"] as? String,
            let events = json["events"] as? [[String: Any]] else {
                print("JSON does not conform to Athletic Date Prototype JSON")
                return
        }

        let athleticDate = AthleticDate()
        athleticDate.date = date

        for event in events {
            addOrUpdateAthleticEvent(athleticDate: athleticDate, fromJSON: event)
        }

        do {
            try realm.write {
                realm.add(athleticDate, update: true)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }

    static func addOrUpdateAthleticEvent(athleticDate: AthleticDate, fromJSON json: [String:Any]) {

        guard let athleticEvent = AthleticEvent(fromJSON: json) else {
            print("JSON does not conform to Athletic Event Prototype JSON")
            return
        }

        do {
            try realm.write {
                athleticDate.athleticEvents.append(athleticEvent)
                realm.add(athleticEvent)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }
}
