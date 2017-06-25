//
//  AthleticTableViewCell.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-24.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

class AthleticTableViewCell: UITableViewCell {

//    @IBOutlet weak var athleticTitleLabel: UILabel!
    @IBOutlet weak var campusLocationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var athleticEvent: AthleticEvent!

    func update() {
//        athleticTitleLabel.text = athleticEvent.title
        campusLocationLabel.text = "\(athleticEvent.campus): \(athleticEvent.location)"
        timeLabel.text = "\(athleticEvent.startTime.convertSecondsFromMidnight())-\(athleticEvent.endTime.convertSecondsFromMidnight())"
//        athleticTitleLabel.sizeToFit()
        campusLocationLabel.sizeToFit()
        timeLabel.sizeToFit()
    }
}
