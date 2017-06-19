//
//  UofTAPI+Course.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-18.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import Alamofire

extension UofTAPI {

    static func updateCourseDB() {
        print("DON'T EVER UPDATE COURSES API KNOWLEDGE.")
        print("THERE ARE TOO MANY COURSES FOR THIS TO BE DONE BY THE PHONE.")
        print("ONLY EVER RUN THIS COMMAND IF THERE ARE NO COURSES IN THE DATABASE.")

        if realm.objects(Course.self).count == 0 {
            makeCoursesRequest(skip: 0)
        }
    }

    static func makeCoursesRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .courses, skip: skip, limit: limit)
    }

    static func makeCoursesRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeCoursesRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            print(response.result)
            print("=================")

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {

                for course in JSON {
                    addOrUpdateCourse(fromJSON: course)
                }

                if JSON.count == limit {
                    sleep(5)
                    makeCoursesRequest(skip: skip, limit: limit)
                }
            }
        }
    }

    static func addOrUpdateCourse(fromJSON json: [String:Any]) {
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
            let meetingSections = json["meeting_sections"] as? [[String:Any]],
            let breadths = json["breadths"] as? [Int] else {
                print("JSON does not conform to Course Prototype JSON")
                return
        }

        let course = Course()
        course.id = id
        course.code = code
        course.name = name
        course.courseDescription = courseDescription
        course.division = division
        course.department = department
        course.prerequistes = prerequisites
        course.exclusions = exclusions
        course.level = level
        course.campus = campus
        course.term = term

        for breadth in breadths {
            let realmInt = RealmInt()
            realmInt.int = breadth
            course.breadths.append(realmInt)
        }

        for meetingSection in meetingSections {
            addOrUpdateCourseMeetingSection(course: course, fromJSON: meetingSection)
        }

        try! realm.write {
            realm.add(course, update: true)
        }
    }

    static func addOrUpdateCourseMeetingSection(course: Course, fromJSON json: [String:Any]) {
        guard
            let code = json["code"] as? String,
            let size = json["size"] as? Int,
            let enrolment = json["enrolment"] as? Int,
            let times = json["times"] as? [[String:Any]],
            let instructors = json["instructors"] as? [String] else {
                print("JSON does not conform to Course Meeting Section Prototype JSON")
                return
        }

        let meetingSection = CourseMeetingSection()
        meetingSection.code = code
        meetingSection.size = size
        meetingSection.enrolment = enrolment

        for time in times {
            addOrUpdateCourseTime(meetingSection: meetingSection, fromJSON: time)
        }

        for instructor in instructors {
            let realmString = RealmString()
            realmString.string = instructor
            meetingSection.instructors.append(realmString)
        }

        try! realm.write {
            realm.add(meetingSection)
            course.courseMeetingSections.append(meetingSection)
        }
    }

    static func addOrUpdateCourseTime(meetingSection: CourseMeetingSection, fromJSON json: [String:Any]) {
        guard
            let day = json["day"] as? String,
            let startTime = json["start"] as? Int,
            let endTime = json["end"] as? Int,
            let duration = json["duration"] as? Int,
            let location = json["location"] as? String else {
                print("JSON does not conform to Course Time Prototype JSON")
                return
        }

        let courseTime = CourseTime()
        courseTime.day = day
        courseTime.startTime = startTime
        courseTime.endTime = endTime
        courseTime.duration = duration
        courseTime.location = location

        try! realm.write {
            meetingSection.times.append(courseTime)
        }
    }
}
