//
//  ListTableViewCell.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-12.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import Foundation

class ListTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var listData: UILabel!
    @IBOutlet weak var listNumber: UILabel!
    @IBOutlet weak var listColor: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
