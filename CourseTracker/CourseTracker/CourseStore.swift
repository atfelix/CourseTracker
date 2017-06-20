//
//  CourseStore.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-20.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import RealmSwift

class CourseStore {

    let departments: [CourseShortCode]

    private static let config = Realm.Configuration(shouldCompactOnLaunch: { totalBytes, usedBytes in
        return true
    })
    static let realm = try! Realm(configuration: config)

    init() {
        do {
            try departments = Array(Realm().objects(CourseShortCode.self))
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

    private func coursesForIndex(_ index: Int) -> [Course]? {
        if index < 0 || departments.count <= index {
            return nil
        }

        let department = departments[index].shortCode
        let predicate = NSPredicate(format: "term BEGINSWITH '2017 Summer' AND code BEGINSWITH '\(department)'")
        return Array(CourseStore.realm.objects(Course.self).filter(predicate))
    }
}
