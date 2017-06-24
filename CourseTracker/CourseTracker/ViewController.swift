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

    override func viewDidLoad() {
        super.viewDidLoad()
        //segue to Calendar
        performSegue(withIdentifier: "PresentCalendar", sender: self)
        
//        UofTAPI.updateDB()
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        sleep(5)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
