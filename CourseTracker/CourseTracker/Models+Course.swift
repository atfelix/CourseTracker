//
//  Models+Course.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-23.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import JTAppleCalendar
import RealmSwift

final class CourseMeetingSection: Object {
    dynamic var code = ""
    dynamic var size = 0
    dynamic var enrolment = 0
    let times = List<CourseTime>()
    let instructors = List<RealmString>()

    convenience init?(fromJSON json: [String:Any]) {
        self.init()

        guard
            let code = json["code"] as? String,
            let size = json["size"] as? Int,
            let enrolment = json["enrolment"] as? Int,
            let _ = json["times"] as? [[String:Any]],
            let _ = json["instructors"] as? [String] else {
                print("JSON does not conform to Course Meeting Section Prototype JSON")
                return nil
        }

        self.code = code
        self.size = size
        self.enrolment = enrolment
    }

    dynamic var isLecture: Bool {
        get {
            return code.hasPrefix("L")
        }
    }

    func lecturesConflict(with other: CourseMeetingSection) -> Bool {

        if !isLecture || !other.isLecture {
            return true
        }

        for time in times {
            for otherTime in other.times {
                if CourseTime.timesConflict(time, otherTime) {
                    return true
                }
            }
        }

        return false
    }
}

final class CourseTime: Object {
    dynamic var day = ""
    dynamic var startTime = 0
    dynamic var endTime = 0
    dynamic var duration = 0
    dynamic var location = ""

    convenience init?(fromJSON json: [String:Any]) {
        self.init()

        guard
            let day = json["day"] as? String,
            let startTime = json["start"] as? Int,
            let endTime = json["end"] as? Int,
            let duration = json["duration"] as? Int,
            let location = json["location"] as? String else {
                print("JSON does not conform to Course Time Prototype JSON")
                return nil
        }

        self.day = day
        self.startTime = startTime
        self.endTime = endTime
        self.duration = duration
        self.location = location
    }

    dynamic var building: Building? {
        get {
            var _building: Building? = nil
            let locationSplit = location.components(separatedBy: " ")

            if locationSplit.count == 0 {
                print("No building code for CourseTime")
                return nil
            }

            let buildingCode = locationSplit[0]

            do {
                try _building = Realm().objects(Building.self).filter("code == '\(buildingCode)'").first
            }
            catch {
                print("Realm error occurred: Could not find Building with code: \(buildingCode)")
            }

            return _building
        }
    }

    dynamic var room: String? {
        get {
            let locationSplit = location.components(separatedBy: " ")

            guard locationSplit.count > 1 else {
                print("No building room exists for CourseTime")
                return nil
            }

            return locationSplit[1]
        }
    }

    static func timesConflict(_ time: CourseTime, _ otherTime: CourseTime) -> Bool {
        if time.day != otherTime.day {
            return false
        }
        else if time.startTime <= otherTime.startTime && otherTime.startTime <= time.endTime {
            return true
        }
        else if otherTime.startTime <= time.startTime && time.startTime <= otherTime.endTime {
            return true
        }
        else {
            return false
        }
    }

    func timeAsDayOfWeek() -> Int {
        switch day {
            case "SUNDAY":    return 1
            case "MONDAY":    return 2
            case "TUESDAY":   return 3
            case "WEDNESDAY": return 4
            case "THURSDAY":  return 5
            case "FRIDAY":    return 6
            case "SATURDAY":  return 7
            default:          return -1
        }
    }
}

final class Course: Object {
    dynamic var id = ""
    dynamic var code = ""
    dynamic var name = ""
    dynamic var courseDescription = ""
    dynamic var division = ""
    dynamic var department = ""
    dynamic var prerequistes = ""
    dynamic var exclusions = ""
    dynamic var level = 0
    dynamic var campus = ""
    dynamic var term = ""
    let breadths = List<RealmInt>()
    let courseMeetingSections = List<CourseMeetingSection>()

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init?(fromJSON json: [String:Any]) {
        self.init()

        guard
            let id = json["id"] as? String,
            let code = json["code"] as? String,
            let name = json["name"] as? String,
            let courseDescription = json["description"] as? String,
            let division = json["division"] as? String,
            let department = json["department"] as? String,
            let prerequisites = json["prerequisites"] as? String,
            let exclusions = json["exclusions"] as? String,
            let level = json["level"] as? Int,
            let campus = json["campus"] as? String,
            let term = json["term"] as? String,
            let _ = json["meeting_sections"] as? [[String:Any]],
            let _ = json["breadths"] as? [Int] else {
                print("JSON does not conform to Course Prototype JSON")
                return nil
        }

        self.id = id
        self.code = code
        self.name = name
        self.courseDescription = courseDescription
        self.division = division
        self.department = department
        self.prerequistes = prerequisites
        self.exclusions = exclusions
        self.level = level
        self.campus = campus
        self.term = term
    }

    dynamic var textbooks: [Textbook]{
        get {
            var _textbooks = [Textbook]()
            do {
                let textbooks = try Array(Realm().objects(Textbook.self))

                for textbook in textbooks {
                    for course in textbook.courses {
                        if id == course.id {
                            _textbooks.append(textbook)
                        }
                    }
                }
                return _textbooks
            }
            catch let error {
                print("Realm read error: \(error.localizedDescription)")
                return []
            }
        }
    }

    dynamic var courseTimes: [CourseTime] {
        for courseMeetingSection in courseMeetingSections {
            if courseMeetingSection.isLecture {
                return Array(courseMeetingSection.times)
            }
        }
        return []
    }

    func courseTimeFor(day: JTAppleCalendar.DaysOfWeek) -> [CourseTime] {
        var courseTimes = [CourseTime]()

        for courseTime in self.courseTimes {
            if courseTime.timeAsDayOfWeek() == day.rawValue {
                courseTimes.append(courseTime)
            }
        }
        return courseTimes.sorted(by: { $0.startTime < $1.startTime })
    }
}

final class CourseShortCode: Object {
    dynamic var shortCode = ""

    dynamic var courses: [Course] {
        get {
            do {
                let predicate = NSPredicate(format: "id BEGINSWITH %@ AND term BEGINSWITH %@", shortCode, "2017 Summer")
                return try Array(Realm().objects(Course.self).filter(predicate))
            }
            catch let error {
                print("Realm read error: \(error.localizedDescription)")
                return []
            }
        }
    }
    
    override static func primaryKey() -> String? {
        return "shortCode"
    }

    convenience init?(course: Course) {
        self.init()

        let index = course.id.index(course.id.startIndex, offsetBy:3)
        let code = course.id[Range(course.id.startIndex..<index)]

        guard code.characters.count == 3 else { return nil }

        self.shortCode = code
    }
}
