//
//  ViewController.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-09.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

//import IBAnimatable

class ViewController: UIViewController {
    
    //MARK: Properties
    var student: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delay
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            
            //segue to Calendar
            self.performSegue(withIdentifier: "PresentCalendar", sender: self)
            
        })
        //        UofTAPI.updateDB()
        
        //Student
        var students: [Student]
        
        do {
            students = try Array(Realm().objects(Student.self))
        }
        catch let error {
            print("Realm read error: \(error.localizedDescription)")
            fatalError()
        }
        
        if let _student = students.first {
            student = _student
        }
        else {
            student = Student()
            student.name = "rush"
            
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(student, update: true)
                }
            }
            catch let error {
                print("Realm read error: \(error.localizedDescription)")
                fatalError()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PresentCalendar" {
            let calendarVC = segue.destination as! CalendarViewController
            calendarVC.student = student
        }
    }
    
    
}
