//
//  AddEventViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-14.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar
import EventKit

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

        //set the picker dates to current
        self.startDatePicker.setDate(initialDatePickerValue(), animated: false)
        self.endDatePicker.setDate(initialDatePickerValue(), animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Helper methods
    func initialDatePickerValue() -> Date{
        let calendarUnitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute, .second]

        var dateComponents = (Calendar.current as NSCalendar).components(calendarUnitFlags, from: Date())
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0

        return Calendar.current.date(from: dateComponents)!
    }


    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //add event to Custom Events in User Data
    @IBAction func addEventTapped(_ sender: Any) {

//        let eventStore = EKEventStore()
//
//        //new calendar instance
//        if let calendarForEvent = eventStore.calendar(withIdentifier: self.calendar.calendarIdentifier){
//
//            let newEvent = EKEvent(eventStore: eventStore)
//
//            newEvent.calendar = calendarForEvent
//            newEvent.title = self.eventNameTF.text!
//            newEvent.location = self.eventLocationTF.text!
//            newEvent.startDate = self.startDatePicker.date
//            newEvent.endDate = self.endDatePicker.date
//
//            //save the event using the Event Store instance
//            do {
//                try eventStore.save(newEvent, span: .thisEvent, commit: true)
//                delegate?.eventDidAdd()
//
//                self.dismiss(animated: true, completion: nil)
//            } catch {
//                let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
//                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(OKAction)
//
//                self.present(alert, animated: true, completion: nil)
//
//            }
//
//        }
    }
}
