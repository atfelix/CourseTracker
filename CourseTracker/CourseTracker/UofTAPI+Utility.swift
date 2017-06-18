//
//  UofTAPI+Utility.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-17.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation

extension UofTAPI {

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    static func addOrUpdateEvent(fromJSON json: [String:Any]) {
        guard
            let dateString = json["date"] as? String,
            let eventsOnDate = json["events"] as? [[String:Any]] else {
                print(#file, #function, #line, "JSON does not conform to Events Prototype JSON")
                return
        }

        for eventJSON in eventsOnDate {
            guard
                let title = eventJSON["title"] as? String,
                let location = eventJSON["location"] as? String,
                let buildingID = eventJSON["building_id"] as? String else {
                    print(#file, #function, #line, "JSON does not conform to Event Prototype JSON")
                    continue
            }
            let event = Event()
            event.title = title
            event.location = location

            let time = Time()
            addOrUpdateTime(time: time, fromJSON: eventJSON, dateString: dateString)

            event.time = time
            event.building = realm.objects(Building.self).filter("id == '\(buildingID)'").first
            event.id = [dateString, buildingID, title, "\(time.startTime)", "\(time.endTime)"].joined(separator: "##")

            try! realm.write {
                realm.add(event, update: true)
            }
        }
    }

    static func addOrUpdateTime(time: Time, fromJSON json: [String: Any], dateString: String?) {
        guard
            let startTime = json["start_time"] as? Int,
            let endTime = json["end_time"] as? Int,
            let duration = json["duration"] as? Int else {
                print("JSON does not conform to Time Prototype JSON")
                return
        }

        time.dayOfWeek = json["day"] as? String
        time.date = dateFormatter.date(from: dateString ?? "")! as NSDate
        time.startTime = startTime
        time.endTime = endTime
        time.duration = duration
        time.id = [time.dayOfWeek ?? "NO DAY OF WEEK", "\(time.date?.description ?? "NO DATE")", "\(time.startTime)", "\(time.endTime)", "\(time.duration)"].joined(separator: " ## ")
        
        try! realm.write {
            realm.add(time, update: true)
        }
    }
}
