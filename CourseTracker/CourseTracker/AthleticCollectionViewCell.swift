//
//  AthleticCollectionViewCell.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-24.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

class AthleticCollectionViewCell: UICollectionViewCell {
    
    
    //MARK: Properties
    @IBOutlet weak var eventBackgroundView: UIView!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    
    var athleticEvent: AthleticEvent!
    var athleticLocation = [AthleticEvent]()
    
    
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
    
//    func getLocations(athleticLocation: [AthleticEvent]){
//        let allKeys = Set<String>((AthleticEvent.filter{!$0.location.isEmpty}).map{$0.location})
//        for key in allKeys {
//            let sum = AthleticEvent.filter({$0.location == key}).map({$0.value}).reduce(0, +)
//            athleticLocation.append(AthleticEvent(value:sum, name:key))
//        }
//        athleticLocation.sorted(by: {$0.value < $1.value})
//    }
    
    
    func getLocations(athleticLocation:[AthleticEvent?]) {
        if athleticEvent.location.hasPrefix("Gym"){
//            athleticLocation.append()//
        }
        if athleticEvent.location.hasPrefix("Pool") && athleticEvent.location.hasSuffix("Pool"){
            print("This is a pool")
        }
        if athleticEvent.location.hasPrefix("Studio") && athleticEvent.location.hasSuffix("Studio"){
            print("This is a studio")
        }
        if athleticEvent.location.hasPrefix("Fitness Centre"){
            print("This is a fitness centre")
        }
        if athleticEvent.location.hasPrefix("Rock"){
            print("This is the rock climbing wall")
        }
    }
    
    
    func updateUI(){
        eventTitleLabel.text = "\(athleticEvent.location)"
//        eventImageView.image = athleticEvent.image
        eventBackgroundView.backgroundColor = UIColor.random().withAlphaComponent(0.30)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //cell layouts
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width:5, height: 10)
        
        self.clipsToBounds = false
    }
//
}
