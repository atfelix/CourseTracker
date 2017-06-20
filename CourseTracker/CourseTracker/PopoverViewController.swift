//
//  PopoverViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-19.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

protocol SelectedCourses: class {
    func didSelectCourse(course: CourseUI)
}

class PopoverViewController: UIViewController {
    
   var course:CourseUI?
    
    //MARK: Properties
    @IBOutlet var popCourseLabel: UILabel!
    @IBOutlet weak var popDescriptionLabel: UILabel!
    @IBOutlet weak var popTextbookLabel: UILabel!
    
    //buttons
    @IBOutlet weak var addSelected: UIButton!
    
    @IBOutlet weak var cancelSelected: UIButton!
    
    weak var delegate: SelectedCourses?
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.popCourseLabel.text = course?.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Helper Methods
    
    @IBAction func addSelectedTapped(_ sender: Any) {
        //add the selected cell to the tableview Cell

        delegate?.didSelectCourse(course: self.course!)
        
        
        self.dismiss(animated: true, completion: nil)
        
    }

    @IBAction func cancelSelectedTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
