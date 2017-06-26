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
    var category: String!
    
    //groups of events
    var gym = [AthleticEvent]()
    var pool = [AthleticEvent]()
    var studio =  [AthleticEvent]()
    var fitness = [AthleticEvent]()
    var rock = [AthleticEvent]()
    var misc = [AthleticEvent]()
    
    
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
    
//        func getLocations(athleticLocation: [AthleticEvent]){
//            let allKeys = Set<String>((AthleticEvent.filter{!$0.location.isEmpty}).map{$0.location})
//            for key in allKeys {
//                let sum = AthleticEvent.filter({$0.location == key}).map({$0.value}).reduce(0, +)
//                athleticLocation.append(AthleticEvent(value:sum, name:key))
//            }
//            athleticLocation.sorted(by: {$0.value < $1.value})
//        }
//    
//    
//    func getLocations(athleticLocation:[AthleticEvent?]) {
//        let str = athleticEvent.location
//        switch(str){
//        case let x where x.hasPrefix("Gym"):
//            
////            print("This is a gym")
//        case let x where x.hasPrefix("Pool"), let x where x.hasSuffix("Pool"):
//            print("This is a pool")
//        case let x where x.hasPrefix("Studio"), let x where x.hasSuffix("Studio"):
//            print("This is a studio")
//        case let x where x.hasPrefix("Fitness Centre"):
//            print("This is a fitness")
//        case let x where x.hasPrefix("Rock"):
//            print("This is a rock climbing wall")
//        default:
//            print("Misc")
//        }
//    }
//    Realm().objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: date))'").first!
    //            athleticLocation.append()
    
    
    
    func updateUI(){
        eventTitleLabel.text = "\(category!)"
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
