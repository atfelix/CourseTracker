//
//  ViewController.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-09.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //UofTAPI.makeBuildingRequest(skip: 0)
        UofTAPI.makeAthleticsRequest(skip: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
