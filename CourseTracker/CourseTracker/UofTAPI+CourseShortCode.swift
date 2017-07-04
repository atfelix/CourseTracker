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
        guard let shortCode = CourseShortCode(course: course) else { return }

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
