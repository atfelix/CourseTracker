//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    //Tableview Headers
    var previouslySelectedHeaderIndex: Int?
    var selectedHeaderIndex: Int?
    var selectedItemIndex: Int?
    
    var cells: CourseTableViewCell!
    
    //MARK: ViewdidLoad
    override func viewDidLoad() {
        //Set the tableview
        cells = CourseTableViewCell()
        self.setup()
        self.courseTableView.estimatedRowHeight = 45
        self.courseTableView.rowHeight = UITableViewAutomaticDimension
        self.courseTableView.allowsMultipleSelection = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.courseTableView.reloadData() //reload tableview
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Add button
    @IBAction func addButtonTapped(_ sender: UIButton) {
        if let selectedItemIndex = self.selectedItemIndex {
            let selectedItemValue = self.cells.items[selectedItemIndex].value
            
            let alert = UIAlertController(title: "Current Selection", message: selectedItemValue, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    //MARK: Helper Methods
    //set up the input
    func setup(){
        self.addButton.layer.cornerRadius = 4
        
        self.cells.append(CourseTableViewCell.HeaderItem(value: "Computer Sceince"))
        self.cells.append(CourseTableViewCell.Item(value: "Course 1"))
        self.cells.append(CourseTableViewCell.Item(value: "Course 2"))
        self.cells.append(CourseTableViewCell.Item(value: "Course 3"))
        self.cells.append(CourseTableViewCell.HeaderItem(value: "Business"))
        self.cells.append(CourseTableViewCell.Item(value: "Course 1"))
        self.cells.append(CourseTableViewCell.Item(value: "Course 2"))
        self.cells.append(CourseTableViewCell.Item(value: "Course 3"))
        self.cells.append(CourseTableViewCell.HeaderItem(value: "Engineering"))
        self.cells.append(CourseTableViewCell.Item(value: "Course 1"))
        self.cells.append(CourseTableViewCell.HeaderItem(value: "Economics"))
        self.cells.append(CourseTableViewCell.Item(value: "Course 1"))

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cells.items.count
    }
    
    //Dequeue cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        let value = item.value
        let isChecked = item.isChecked as Bool
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") {
            cell.textLabel?.text = value
            //header selection
            if item as? CourseTableViewCell.HeaderItem != nil {
                cell.backgroundColor = UIColor.black
                cell.textLabel?.textColor = UIColor.white
                cell.accessoryType = .none
            } else {
                if isChecked {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    //Handles the drop down
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is CourseTableViewCell.HeaderItem {
            return 60
        } else if (item.isHidden) {
            return 0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //Select a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.cells.items[(indexPath as NSIndexPath).row]
        
        if item is CourseTableViewCell.HeaderItem {
            if self.selectedHeaderIndex == nil {
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            } else {
                self.previouslySelectedHeaderIndex = self.selectedHeaderIndex
                self.selectedHeaderIndex = (indexPath as NSIndexPath).row
            }
            
            if let previouslySelectedHeaderIndex = self.previouslySelectedHeaderIndex {
                self.cells.collapse(previouslySelectedHeaderIndex)
            }
            
            if self.previouslySelectedHeaderIndex != self.selectedHeaderIndex {
                self.cells.expand(self.selectedHeaderIndex!)
            } else {
                self.selectedHeaderIndex = nil
                self.previouslySelectedHeaderIndex = nil
            }
            
            self.courseTableView.beginUpdates()
            self.courseTableView.endUpdates()
            
        } else {
            if (indexPath as NSIndexPath).row != self.selectedItemIndex {
                let cell = self.courseTableView.cellForRow(at: indexPath)
                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
                
                if let selectedItemIndex = self.selectedItemIndex {
                    let previousCell = self.courseTableView.cellForRow(at: IndexPath(row: selectedItemIndex, section: 0))
                    previousCell?.accessoryType = UITableViewCellAccessoryType.none
                    cells.items[selectedItemIndex].isChecked = false
                }
                
                self.selectedItemIndex = (indexPath as NSIndexPath).row
                cells.items[self.selectedItemIndex!].isChecked = true
            }
        }
    }

}
