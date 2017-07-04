////
////  UserData.swift
////  CourseTracker
////
////  Created by Rushan on 2017-06-13.
////  Copyright © 2017 Adam Felix. All rights reserved.
////
//
//import UIKit
//
////event protocol
//protocol EventProtocol {
//    var title : String {get set}
//    var location: String {get set}
//    var startDate: Date { get set }
//    var endDate: Date {get set}
//    var color : UIColor {get set}
//}
//
////declare course events
//class CourseEvent: EventProtocol{
//    var title : String
//    var location: String
//    var startDate: Date
//    var endDate: Date
//    var color : UIColor
//    
//    init(title: String, location: String, startDate: Date, endDate: Date, color: UIColor = UIColor.init(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)) {
//        self.title = title
//        self.location = location
//        self.startDate = startDate
//        self.endDate = endDate
//        self.color = color
//    }
//    
//}
//
////declare custom events
//class CustomEvent: EventProtocol{
//    var title: String
//    var location: String
//    var startDate: Date
//    var endDate: Date
//    var color: UIColor
//    
//    init(title: String, location: String, startDate: Date, endDate : Date, color: UIColor = UIColor.init(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)){
//        self.title = title
//        self.location = location
//        self.startDate = startDate
//        self.endDate = endDate
//        self.color = color
//    }
//
//}
//
////initialize User Data from API
//class UserData {
//    var events : [EventProtocol]?
//    
//    
//    init() {
//        //temp data
//        let courseA = CourseEvent(title: "COSC1390", location: "Campus A",  startDate: Date(), endDate: Date())
//        let courseB = CourseEvent(title: "MFMO1234", location: "Campus B", startDate: Date(), endDate: Date())
//        let courseC = CourseEvent(title: "PLAF9232", location: "Campus C", startDate: Date(), endDate: Date())
//        
//        let customA = CustomEvent(title: "Dinner with friend", location: "Bennys Bar", startDate: Date(), endDate: Date())
//        let customB = CustomEvent(title: "Gym", location: "Bennys Gym", startDate: Date(), endDate: Date())
//        
//        //add events to array
//        events = []
//        events?.append(courseA)
//        events?.append(courseB)
//        events?.append(customA)
//        events?.append(courseC)
//        events?.append(customB)
//    }
//}
//
