//
//  Models+Athletics.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-23.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import RealmSwift

final class AthleticDate: Object {
    dynamic var date: String?
    let athleticEvents = List<AthleticEvent>()

    override static func primaryKey() -> String? {
        return "date"
    }
}

final class AthleticEvent: Object {
    dynamic var title = ""
    dynamic var campus = ""
    dynamic var location = ""
    dynamic var buildingID = ""
    dynamic var startTime = 0
    dynamic var endTime = 0
    dynamic var duration = 0
    dynamic var studentAttending = false

    dynamic var building: Building? {
        get {
            var _building: Building? = nil
            do {
                try _building = Realm().objects(Building.self).filter("id == '\(buildingID)'").first
            }
            catch {
                print("Realm Error occurred:  Could not find building")
            }
            return _building
        }
    }

    convenience init?(fromJSON json: [String:Any]) {
        self.init()

        guard
            let title = json["title"] as? String,
            let campus = json["campus"] as? String,
            let location = json["location"] as? String,
            let buildingID = json["building_id"] as? String,
            let startTime = json["start_time"] as? Int,
            let endTime = json["end_time"] as? Int,
            let duration = json["duration"] as? Int else {
                print("JSON does not conform to Athletic Event Prototype JSON")
                return nil
        }

        self.title = title
        self.campus = campus
        self.location = location
        self.buildingID = buildingID
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
    }
}
