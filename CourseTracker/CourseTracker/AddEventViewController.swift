//
//  AddEventViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-14.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar

class AddEventViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var eventNameTF: UITextField!
    @IBOutlet weak var eventLocationTF: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    @IBOutlet weak var addEvent: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    //MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set color for Nav bar
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = true
    
        
        //set color for Date Picker
        self.startDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        self.startDatePicker.setValue(false, forKeyPath: "highlightsToday")
        self.endDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
        self.endDatePicker.setValue(false, forKeyPath: "highlightsToday")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //add event to Custom Events in User Data
    @IBAction func addEventTapped(_ sender: Any) {
//        let newEvent = UserData()
//        
//        if let calendarForEvent = newEvent.events?.append(CustomEvent){
//            let newEvent =
//            //set events to custom events
//            newEvent.title = self.eventNameTF.text
//            newEvent.startDate = self.startDatePicker.date
//            newEvent.endDate = self.endDatePicker.date
        
        }
}

