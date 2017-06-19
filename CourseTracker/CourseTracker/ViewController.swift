//
//  ViewController.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-09.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var continueButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.layer.cornerRadius = 4
        // UofTAPI.makeBuildingRequest(skip: 0)
        // UofTAPI.makeAthleticsRequest(skip: 0)
        // UofTAPI.makeParkingRequest(skip: 0)
        // UofTAPI.makeTextbooksRequest(skip: 0)
        // UofTAPI.makeCoursesRequest(skip: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
