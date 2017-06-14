//
//  UserData.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-13.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

//event protocol
protocol Event {
    var title : String {get set}
    var startDate: Date { get set }
    var endDate: Date {get set}
    var color : UIColor {get set}
}

//declare course events
class CourseEvent: Event{
    var title : String
    var startDate: Date
    var endDate: Date
    var color : UIColor
    
    init(title: String, startDate: Date, endDate: Date, color: UIColor = UIColor.red) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
    }
    
}

//declare custom events
class CustomEvent: Event{
    var title: String
    var startDate: Date
    var endDate: Date
    var color: UIColor
    
    init(title: String, startDate: Date, endDate : Date, color: UIColor = UIColor.blue){
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
    }
}

//initialize User Data from API
class UserData {
    var events : [Event]?
    
    init() {
        
        let courseA = CourseEvent(title: "COSC1390", startDate: Date(), endDate: Date())
        let courseB = CourseEvent(title: "MFMO1234", startDate: Date(), endDate: Date())
        let courseC = CourseEvent(title: "PLAF9232", startDate: Date(), endDate: Date())
        
        events = []
        events?.append(courseA)
        events?.append(courseB)
        events?.append(courseC)
    }
}

