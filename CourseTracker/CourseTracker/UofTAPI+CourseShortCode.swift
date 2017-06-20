//
//  UofTAPI+Department.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-20.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation

extension UofTAPI {

    static func createCouseShortCodeinDB() {
        let courses = realm.objects(Course.self)

        for course in courses {
            addOrUpdateCourseShortCode(course: course)
        }
    }

    static func addOrUpdateCourseShortCode(course: Course) {
        let index = course.id.index(course.id.startIndex, offsetBy:3)
        let code = course.id[Range(course.id.startIndex..<index)]

        guard code.characters.count == 3 else { return }

        let shortCode = CourseShortCode()
        shortCode.shortCode = code

        do {
            try realm.write {
                realm.add(shortCode, update: true)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }
}
