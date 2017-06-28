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

    @IBOutlet weak var athleticTitleLabel: UILabel!
    @IBOutlet weak var campusLocationLabel: UILabel!

    var athleticEvent: AthleticEvent!

    func update() {
        athleticTitleLabel.text = athleticEvent.title
        campusLocationLabel.text = "\(athleticEvent.campus): \(athleticEvent.location)\n\(athleticEvent.startTime.convertSecondsFromMidnight())-\(athleticEvent.endTime.convertSecondsFromMidnight())"
        athleticTitleLabel.sizeToFit()
        campusLocationLabel.sizeToFit()
    }
}
