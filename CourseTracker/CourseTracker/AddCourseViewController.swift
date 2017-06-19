//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    //temp info
    var departments = ["Computer Science", "Drama", "Earth Science", "Geography", "Mathematics"]

    
    //MARK: Properties
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: ViewdidLoad
    override func viewDidLoad() {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Methods
    
    //Add button
    @IBAction func addButtonTapped(_ sender: UIButton) {

        performSegue(withIdentifier: "ShowCalendar", sender: sender)
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return departments[section]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return departments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell") as! DepartmentTableViewCell
        return cell
    }
}
