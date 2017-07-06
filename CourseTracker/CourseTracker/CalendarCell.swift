//
//  CalendarCell.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-11.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar


class CalendarCell: JTAppleCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    @IBOutlet weak var todayView: UIView!
    
    @IBOutlet weak var coursesLabel: UILabel!
    @IBOutlet weak var customLabel: UILabel!

    override func prepareForReuse() {
        dateLabel.backgroundColor = UIColor.clear
        todayView.backgroundColor = UIColor.clear
        todayView.isHidden = true
    }
}
