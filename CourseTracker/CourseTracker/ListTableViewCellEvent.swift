//
//  ListTableViewCellEvent.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-06.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar

struct ListTableViewCellEvent {
    let imageName: String
    let backgroundColor: UIColor
    let location: String
    let data: String
    let numberOfLines: Int
    let timeString: String

    init(for day: DaysOfWeek, from course: Course) {
        self.imageName = "ic_account_balance_white"
        self.backgroundColor = UIColor.init(red: 191/255, green: 150/255, blue: 94/255, alpha: 0.10)
        self.location = "\(course.campus): \(course.courseTimeFor(day: day).first!.location)"
        self.data = course.name
        self.numberOfLines = 0

        if let firstTime = course.courseTimeFor(day: day).first {
            self.timeString = "\(firstTime.startTime.convertSecondsFromMidnight())\n\(firstTime.endTime.convertSecondsFromMidnight())"
        }
        else {
            self.timeString = "NO TIME\nAVAILABLE"
        }
    }

    init(from event: AthleticEvent) {
        self.imageName = "ic_pool_white"
        self.backgroundColor = UIColor.init(red: 102/255, green: 0/255, blue: 0/255, alpha: 0.10)
        self.location = "\(event.campus): \(event.location)"
        self.data = event.title
        self.numberOfLines = 0
        self.timeString = "\(event.startTime.convertSecondsFromMidnight())\n\(event.endTime.convertSecondsFromMidnight())"
    }
}
