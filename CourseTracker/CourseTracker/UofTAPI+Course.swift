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
            logResponseInfo(response: response)

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {

                for course in JSON {
                    addOrUpdateCourse(fromJSON: course)
                }

                if JSON.count == limit {
                    sleep(5)
                    makeCoursesRequest(skip: skip + limit, limit: limit)
                }
            }
        }
    }

    static func addOrUpdateCourse(fromJSON json: [String:Any]) {
        guard
            let course = Course(fromJSON: json),
            let meetingSections = json["meeting_sections"] as? [[String:Any]],
            let breadths = json["breadths"] as? [Int] else {
                print("JSON does not conform to Course Prototype JSON")
                return
        }

        for breadth in breadths {
            course.breadths.append(RealmInt(int: breadth))
        }

        for meetingSection in meetingSections {
            addOrUpdateCourseMeetingSection(course: course, fromJSON: meetingSection)
        }

        do {
            try realm.write {
                realm.add(course, update: true)
            }
        }
        catch let error {
             UofTAPI.logRealmError(error)
        }
    }

    static func addOrUpdateCourseMeetingSection(course: Course, fromJSON json: [String:Any]) {
        guard
            let times = json["times"] as? [[String:Any]],
            let instructors = json["instructors"] as? [String],
            let meetingSection = CourseMeetingSection(fromJSON: json) else {
            print("JSON does not conform to Course Meeting Section Prototype JSON")
                return
        }

        for time in times {
            addOrUpdateCourseTime(meetingSection: meetingSection, fromJSON: time)
        }

        for instructor in instructors {
            meetingSection.instructors.append(RealmString(string: instructor))
        }

        do {
            try realm.write {
                realm.add(meetingSection)
                course.courseMeetingSections.append(meetingSection)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }

    static func addOrUpdateCourseTime(meetingSection: CourseMeetingSection, fromJSON json: [String:Any]) {
        guard let courseTime = CourseTime(fromJSON: json) else {
                print("JSON does not conform to Course Time Prototype JSON")
                return
        }

        do {
            try realm.write {
                meetingSection.times.append(courseTime)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }
}
