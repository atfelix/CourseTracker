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

    static var realm: Realm!
    private static var allDepartments = [CourseShortCode]()
    static var departments = [CourseShortCode]()
    static var courses = [Course]()
    static var sectionsToCollapse = [Int]()
    static let shared = CourseStore()
    weak static var delegate: CourseStoreDelegate?

    private override init() {}

    static func setup() {
        resetAllDepartments()
        CourseStore.departments = CourseStore.allDepartments
        resetCourses()
    }

    static func resetAllDepartments() {
        let _departmentCodes = Array(CourseStore.realm.objects(CourseShortCode.self))

        for code in _departmentCodes {
            if CourseStore.countForCourses(code: code) > 0 {
                CourseStore.allDepartments.append(code)
            }
        }
    }

    static func filterDepartments(by searchText: String) {
        let predicate = NSPredicate(format: "shortCode contains[c] '\(searchText)'")
        CourseStore.departments = CourseStore.allDepartments.filter { (searchText.isEmpty) ? true : predicate.evaluate(with: $0) }
    }

    static func resetCourses() {
        let _courses = Array(CourseStore.realm.objects(Course.self).filter("term BEGINSWITH '2017 Summer'"))

        for course in _courses {
            if course.courseMeetingSections.count > 0 {
                CourseStore.courses.append(course)
            }
        }
    }

    static func numberOfRowsInEachGroup(_ index: Int) -> Int {
        guard let rowsInGroup = CourseStore.coursesForIndex(index) else {
            return -1
        }

        return rowsInGroup.count
    }

    static func numberOfGroups() -> Int {
        return CourseStore.departments.count
    }

    static func getGroupLabelAtIndex(_ index: Int) -> String {
        return CourseStore.departments[index].shortCode
    }

    static func coursesInGroup(_ index: Int) -> [Course] {
        guard let rowsInGroup = CourseStore.coursesForIndex(index) else {
            return []
        }

        return rowsInGroup
    }
    
    static func deleteItems(courses: [Course]) {
        for course in courses {
            guard let index = CourseStore.courses.index(of: course) else { continue }

            CourseStore.courses.remove(at: index)
        }
    }

    static private func coursesForIndex(_ index: Int) -> [Course]? {
        if index < 0 || CourseStore.departments.count <= index {
            return nil
        }

        let department = CourseStore.departments[index].shortCode
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

    static func courseFor(indexPath: IndexPath) -> Course? {
        guard let courses = CourseStore.coursesForIndex(indexPath.section) else {
                return nil
        }

        return courses[indexPath.item]
    }
}
