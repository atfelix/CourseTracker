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

    @IBOutlet weak var continueButton: UIButton!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.layer.cornerRadius = 4
        var users: [User]
        
        do {
            users = try Array(Realm().objects(User.self))
        }
        catch let error {
            print("Realm read error: \(error.localizedDescription)")
            fatalError()
        }
        
        if let _user = users.first {
            user = _user
        }
        else {
            user = User()
        }
//        UofTAPI.updateDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Continue" {
            let addCourseVC = segue.destination as! AddCourseViewController
            addCourseVC.user = user
        }
    }
    
    
    //1) put selected courses inside a cache
    //2) tap on each course will present a pop over view
            //-this will show textbook prices
            //title, edition, author, imageURL, price
            //then click cancel or add to add it to a cache
    
    
}
