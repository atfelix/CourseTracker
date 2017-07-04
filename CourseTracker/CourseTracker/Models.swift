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

    convenience init(string: String) {
        self.init()
        self.string = string
    }
}

final class RealmInt: Object {
    dynamic var int = 0

    convenience init(int: Int) {
        self.init()
        self.int = int
    }
}

final class GeoLocation: Object {
    dynamic var longitude: Double = 0.0
    dynamic var latitude: Double = 0.0

    convenience init(latitude: Double, longitude: Double) {
        self.init()

        self.latitude = latitude
        self.longitude = longitude
    }
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

    convenience init?(fromJSON json: [String:String]) {
        self.init()

        guard
            let street = json["street"],
            let city = json["city"],
            let province = json["province"],
            let country = json["country"],
            let postalCode = json["postal"] else {
                print("JSON does not conform to Address Prototype JSON")
                return nil
        }

        self.street = street
        self.city = city
        self.province = province
        self.country = country
        self.postalCode = postalCode
        self.id = [street, city, province, country, postalCode].joined(separator: ", ")
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

    convenience init?(fromJSON json: [String:Any], address: Address?) {
        self.init()

        guard
            let id = json["id"] as? String,
            let code = json["code"] as? String,
            let name = json["name"] as? String,
            let shortName = json["short_name"] as? String,
            let campus = json["campus"] as? String,
            let latitude = json["lat"] as? Double,
            let longitude = json["lng"] as? Double,
            let polygonArray = json["polygon"] as? [[Double]],
            let _ = json["address"] as? [String: String] else {
                print("JSON does not conform to Building Prototype JSON")
                return nil
        }

        self.id = id
        self.code = code
        self.name = name
        self.shortName = shortName
        self.campus = campus
        self.geoLocation = GeoLocation(latitude: latitude, longitude: longitude)

        for location in polygonArray {
            guard location.count == 2 else {
                print("location is not 2 points")
                continue
            }

            self.polygon.append(GeoLocation(latitude: location[0], longitude: location[1]))
        }
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

    convenience init?(fromJSON json: [String:Any]) {
        self.init()

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

        self.id = id
        self.title = title
        self.buildingID = buildingID
        self.campus = campus
        self.type = type
        self.parkingDescription = parkingDescription
        self.address = address
        self.geoLocation = GeoLocation(latitude: latitude, longitude: longitude)
    }
}

final class Student: Object{
    dynamic var name: String?
    let courses = List<Course>()
    let athleticEvents = List<AthleticEvent>()

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

        return coursesForDay.sorted(by: { $0.courseTimeFor(day: day).first!.startTime < $1.courseTimeFor(day: day).first!.startTime })
    }
    
    func buildingData(for day: JTAppleCalendar.DaysOfWeek) -> [Building] {
        var buildings = [Building]()
        
        for course in coursesFor(day: day) {
            if let time = course.courseTimeFor(day: day).first,
                let building = time.building {
                buildings.append(building)
            }
        }
        
        return buildings
    }
}
