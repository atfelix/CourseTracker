//
//  Int+TimeUtility.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-24.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation

extension Int {
    func convertSecondsFromMidnight() -> String {
        let minutes = self / 60
        let hour = minutes / 60 % 24
        return String(format: "%d:%02d", hour, minutes % 60)
    }
}
