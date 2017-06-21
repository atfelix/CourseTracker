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

//        UofTAPI.updateDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //1) put selected courses inside a cache
    //2) tap on each course will present a pop over view
            //-this will show textbook prices
            //title, edition, author, imageURL, price
            //then click cancel or add to add it to a cache
    
    
}
