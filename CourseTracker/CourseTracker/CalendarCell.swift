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
    
    //Alerts
    @IBOutlet weak var firstAlert: UIImageView! //red, for Courses
    @IBOutlet weak var secondAlert: UIImageView! //blue for Food
    @IBOutlet weak var thirdAlert: UIImageView!  //green for athletics
    
}
