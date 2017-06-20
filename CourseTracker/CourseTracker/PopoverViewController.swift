//
//  PopoverViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-19.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet var popCourseLabel: UILabel!

    @IBOutlet weak var addSelected: UIButton!
    
    @IBOutlet weak var cancelSelected: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addSelectedTapped(_ sender: Any) {
        
    }

    @IBAction func cancelSelectedTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
