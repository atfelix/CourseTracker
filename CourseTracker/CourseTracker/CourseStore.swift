//
//  CourseStore.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-20.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

protocol CourseStoreDelegate: class {
    func reloadData()
}

class CourseStore: NSObject {
    
    var departments = [CourseShortCode]()
    var courses = [Course]()
    var sectionsToCollapse = [Int]()
    weak var delegate: CourseStoreDelegate!

    private static let config = Realm.Configuration(shouldCompactOnLaunch: { totalBytes, usedBytes in
        return true
    })
    static let realm = try! Realm(configuration: config)

    override init() {
        do {
            let _departmentCodes: [CourseShortCode]
            let _courses: [Course]
            try _departmentCodes = Array(Realm().objects(CourseShortCode.self))
            try _courses = Array(Realm().objects(Course.self).filter("term BEGINSWITH '2017 Summer'"))

            for code in _departmentCodes {
                if CourseStore.countForCourses(code: code) > 0 {
                    departments.append(code)
                }
            }
            
            for course in _courses {
                if course.courseMeetingSections.count > 0 {
                    courses.append(course)
                }
            }
        }
        catch let error {
            print("Error: \(error.localizedDescription)")
            fatalError("Realm read error: could not read departments")
        }
    }

    func numberOfRowsInEachGroup(_ index: Int) -> Int {
        guard let rowsInGroup = coursesForIndex(index) else {
            return -1
        }

        return rowsInGroup.count
    }

    func numberOfGroups() -> Int {
        return departments.count
    }

    func getGroupLabelAtIndex(_ index: Int) -> String {
        return departments[index].shortCode
    }

    func coursesInGroup(_ index: Int) -> [Course] {
        guard let rowsInGroup = coursesForIndex(index) else {
            return []
        }

        return rowsInGroup
    }
    
    func deleteItems(courses: [Course]) {
        for course in courses {
            guard let index = self.courses.index(of: course) else { continue }

            self.courses.remove(at: index)
        }
    }

    private func coursesForIndex(_ index: Int) -> [Course]? {
        if index < 0 || departments.count <= index {
            return nil
        }

        let department = departments[index].shortCode
        let predicate = NSPredicate(format: "term BEGINSWITH '2017 Summer' AND code BEGINSWITH '\(department)' AND courseMeetingSections.@count > 0")
        let courses = Array(CourseStore.realm.objects(Course.self).filter(predicate))
        return courses
    }

    static private func countForCourses(code: CourseShortCode) -> Int {
        return CourseStore.coursesForCode(code: code).count
    }

    static private func coursesForCode(code: CourseShortCode) -> [Course] {
        let predicate = NSPredicate(format: "term BEGINSWITH '2017 Summer' AND code BEGINSWITH '\(code.shortCode)'")
        return Array(CourseStore.realm.objects(Course.self).filter(predicate)) 
    }

    func courseFor(indexPath: IndexPath) -> Course? {
        guard
            let courses = coursesForIndex(indexPath.section) else {
                return nil
        }
        return courses[indexPath.item]
    }
}
