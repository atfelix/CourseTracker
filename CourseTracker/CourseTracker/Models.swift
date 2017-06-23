//
//  Models.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-15.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import RealmSwift
import JTAppleCalendar

final class RealmString: Object {
    dynamic var string: String?
}

final class RealmInt: Object {
    dynamic var int = 0
}

final class GeoLocation: Object {
    dynamic var longitude: Double = 0.0
    dynamic var latitude: Double = 0.0
}

final class Address: Object {
    dynamic var id = ""
    dynamic var street = ""
    dynamic var city = ""
    dynamic var province = ""
    dynamic var country = ""
    dynamic var postalCode = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Building: Object {
    dynamic var id = ""
    dynamic var code = ""
    dynamic var name = ""
    dynamic var shortName = ""
    dynamic var campus = ""
    dynamic var address: Address?
    dynamic var geoLocation: GeoLocation?

    let polygon = List<GeoLocation>()

    override static func primaryKey() -> String? {
        return "id"
    }
}

final class ParkingLocation: Object {
    dynamic var id = ""
    dynamic var title = ""
    dynamic var buildingID = ""
    dynamic var campus = ""
    dynamic var type = ""
    dynamic var parkingDescription = ""
    dynamic var geoLocation: GeoLocation?
    dynamic var address: String?

    override static func primaryKey() -> String? {
        return "id"
    }
}

final class Student: Object{
    dynamic var name: String?
    let courses = List<Course>()

    override static func primaryKey() -> String? {
        return "name"
    }

    func coursesFor(day: JTAppleCalendar.DaysOfWeek) -> [Course] {
        var coursesForDay = [Course]()

        for course in courses {
            for time in course.courseTimes {
                if time.timeAsDayOfWeek() == day.rawValue {
                    coursesForDay.append(course)
                    break
                }
            }
        }

        return coursesForDay
    }
}
