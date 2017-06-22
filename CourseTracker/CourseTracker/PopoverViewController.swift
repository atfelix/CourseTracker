//
//  PopoverViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-19.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

protocol SelectedCourses: class {
    func didSelectCourse(course: Course)
    func didCancel()
}

class PopoverViewController: UIViewController {
    
    var course:Course?
    
    //MARK: Properties
    @IBOutlet var popCourseLabel: UILabel!
    //labels
    @IBOutlet weak var popDescriptionLabel: UILabel!
    @IBOutlet weak var popTextbookLabel: UILabel!
    
    //buttons
    @IBOutlet weak var addSelected: UIButton!
    @IBOutlet weak var cancelSelected: UIButton!
    
    weak var delegate: SelectedCourses?
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set the pop over labels
        self.popCourseLabel.text = course?.name ?? "No Course Name Found"
        self.popDescriptionLabel.text = course?.courseDescription
        var textbookText = "No Textbooks"
        if let firstTextbook = course?.textbooks.first {
            textbookText = String(format: "\(firstTextbook.title): $%.2f", firstTextbook.price)
        }
        self.popTextbookLabel.text =  textbookText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Methods
    
    @IBAction func addSelectedTapped(_ sender: Any) {
        //add the selected cell to the tableview Cell
        delegate?.didSelectCourse(course: course!)
    }
    
    @IBAction func cancelSelectedTapped(_ sender: Any) {
        delegate?.didCancel()
    }
    
    
}
