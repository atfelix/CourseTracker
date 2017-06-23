//
//  Date+Utility.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-23.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation

extension Date {
    var dayOfWeek: Int {
        get {
            return Calendar(identifier: .gregorian).component(.weekday, from: self)
        }
    }
}
