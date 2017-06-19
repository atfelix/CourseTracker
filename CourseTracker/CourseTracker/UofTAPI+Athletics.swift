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

    static func updateAthleticsDB() {
        guard
            let latestAthleticsDate = realm.objects(AthleticDate.self).sorted(byKeyPath: "date", ascending:false).first,
            let latestDate = latestAthleticsDate.date else {
                print(#function, #line, "Realm couldn't get AthleticDate objects")
                makeAthleticsRequest(skip: 0)
                return
        }
        makeAthleticsLatestDateRequest(latestDate:latestDate)
    }

    static func makeAthleticsRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .athletics, skip: skip, limit: limit)
    }

    static func makeAthleticsLatestDateRequestURL(latestDate: String) -> URL? {

        var components = URLComponents()
        components.scheme = UofTAPI.httpScheme
        components.host = UofTAPI.baseURLString
        components.path = UofTAPI.pathStart + Method.athletics.rawValue

        guard var urlString = components.url?.absoluteString else { return nil }

        urlString += "/filter?limit=\(UofTAPI.maxLimit)q=date:>\(latestDate)"

        return URL(string: urlString)
    }

    static func makeAthleticsRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeAthleticsRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            print(response.result)
            print("================")

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for athleticDate in JSON {
                    addOrUpdateAthleticDate(fromJSON: athleticDate)
                }
                makeAthleticsRequest(skip: skip + limit, limit: limit)
            }
        }
    }

    static func makeAthleticsLatestDateRequest(latestDate: String) {
        guard let url = makeAthleticsLatestDateRequestURL(latestDate: latestDate) else { return }
        Alamofire.request(url.absoluteString).responseJSON { response in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            print(response.result)
            print("================")

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                makeAthleticsRequest(skip: 0)
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

        try! realm.write {
            realm.add(athleticDate, update: true)
        }
    }

    static func addOrUpdateAthleticEvent(athleticDate: AthleticDate, fromJSON json: [String:Any]) {
        guard
            let title = json["title"] as? String,
            let campus = json["campus"] as? String,
            let location = json["location"] as? String,
            let buildingID = json["building_id"] as? String,
            let startTime = json["start_time"] as? Int,
            let endTime = json["end_time"] as? Int,
            let duration = json["duration"] as? Int else {
                print("JSON does not conform to Athletic Event Prototype JSON")
                return
        }

        let athleticEvent = AthleticEvent()
        athleticEvent.title = title
        athleticEvent.campus = campus
        athleticEvent.location = location
        athleticEvent.buildingID = buildingID
        athleticEvent.startTime = startTime
        athleticEvent.endTime = endTime
        athleticEvent.duration = duration

        try! realm.write {
            athleticDate.athleticEvents.append(athleticEvent)
            realm.add(athleticEvent)
        }
    }
}
