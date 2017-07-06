//
//  CalendarViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-11.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RealmSwift

class CalendarViewController: UIViewController {

    var realm: Realm!
    var student: Student!
    var redrawTableView = false
    var athleticDate: AthleticDate? {
        get {
            let dateFormatter : DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            }()
            return realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: calendarView.selectedDates.first ?? Date()))'").first
        }
    }

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var dateTapped: UILabel!

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var slidingView: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var addCourseButton: UIButton!
}
