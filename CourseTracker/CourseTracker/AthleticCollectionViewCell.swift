//
//  AthleticCollectionViewCell.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-24.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class AthleticCollectionViewCell: UICollectionViewCell {
    
    
    //MARK: Properties
    
    @IBOutlet weak var eventBackgroundView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
//    
//    var event: Event?{
//        didSet{
//            self.updateUI()
//        }
//    }
//    
//    private func updateUI(){
//        if let event = event{
//            eventBackgroundView.backgroundColor = event.color
//            eventImageView.image = event.eventImage
//            eventTitleLabel.text = event.title
//        }else{
//            eventBackgroundView.backgroundColor = nil
//            eventImageView.image = nil
//            eventTitleLabel.text = nil
//        }
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        //cell layouts
//        self.layer.cornerRadius = 3.0
//        layer.shadowRadius = 10
//        layer.shadowOpacity = 0.3
//        layer.shadowOffset = CGSize(width:5, height: 10)
//        
//        self.clipsToBounds = false
//    }
//    
}