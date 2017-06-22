//
//  AddUniversityViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

class AddUniversityViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var universityPicker: UIPickerView!
    @IBOutlet weak var continueButton: UIButton!
    
    var pickerData: [String] = [String]()
    var student: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Picker
        self.universityPicker.delegate = self
        self.universityPicker.dataSource = self
        pickerData = ["University of Waterloo", "McGill University", "Brock University", "University of British Columbia", "University of Toronto", "York University", "University of Alberta", "Queen's University", "McMaster University", "University of Guelph", "Carleton University"]
        
        //Button
        continueButton.layer.cornerRadius = 4
        
        //Student
        var students: [Student]
        
        do {
            students = try Array(Realm().objects(Student.self))
        }
        catch let error {
            print("Realm read error: \(error.localizedDescription)")
            fatalError()
        }
        
        if let _student = students.first {
            student = _student
        }
        else {
            student = Student()
            student.name = "rush"
            
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(student, update: true)
                }
            }
            catch let error {
                print("Realm read error: \(error.localizedDescription)")
                fatalError()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: DataSource/ Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //color or font
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let newTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName : UIColor.white])
        return newTitle
    }
    
    //select the item
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCourse" {
            let addCourseVC = segue.destination as! AddCourseViewController
            addCourseVC.student = student
        }
    }

}
