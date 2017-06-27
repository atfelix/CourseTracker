//
//  ViewController.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-09.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    //MARK: Properties
    var student: Student!
    var realm: Realm!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let config = Realm.Configuration(schemaVersion: 1, shouldCompactOnLaunch: { totalBytes, usedBytes in
//            return true
//        })
//        realm = try! Realm(configuration: config)

        //Delay
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            
            //segue to Calendar
            self.performSegue(withIdentifier: "PresentCalendar", sender: self)
            
        })
//                UofTAPI.updateDB()

        let students = Array(realm.objects(Student.self))

        if let _student = students.first {
            student = _student
        }
        else {
            student = Student()
            student.name = "rush"

            do {
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
            calendarVC.realm = realm
        }
    }
}
