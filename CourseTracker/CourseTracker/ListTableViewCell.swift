//
//  ListTableViewCell.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-13.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell{

    //MARK: Tableview Properties
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listTime: UILabel!
    @IBOutlet weak var listData: UILabel!
    @IBOutlet weak var listLocation: UILabel!

    var event: ListTableViewCellEvent!

    func update() {
        print(#function)
        self.listImage.image = UIImage(named: event.imageName)
        self.listView.backgroundColor = event.backgroundColor
        self.listLocation.text = event.location
        self.listData.text = event.data
        self.listTime.numberOfLines = 0
        self.listTime.text = event.timeString
    }
}
