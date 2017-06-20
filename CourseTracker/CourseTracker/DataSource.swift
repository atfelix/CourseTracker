//
//  DataSource.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-19.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation

class DataSource{
    
    init() {
        populateData()
    }
    
    var courses:[CourseUI] = []
    var departments:[String] = []
    
    func numberOfRowsInEachGroup(_ index: Int) -> Int{
        return coursesInGroup(index).count
    }
    
    func numberOfGroups()-> Int{
        return departments.count
    }
    
    func getGroupLabelAtIndex(_ index: Int) -> String{
        return departments[index]
    }
    
    //MARK: Helper Methods
    //Populate the Data
    func populateData() {
        if let path = Bundle.main.path(forResource: "courses", ofType: "plist") {
            if let dictArray = NSArray(contentsOfFile: path) {
                for item in dictArray {
                    if let dict = item as? NSDictionary {
                        let name = dict["name"] as! String
                        let dept = dict["department"] as! String
                        
                        let course = CourseUI(name: name, department: dept)
                        if !departments.contains(dept){
                            departments.append(dept)
                        }
                        courses.append(course)
                    }
                }
            }
        }
    }
    
    //Courses for each Group
    func coursesInGroup(_ index: Int) -> [CourseUI]{
        let item = departments[index]
        let filteredCourses = courses.filter { (course: CourseUI) -> Bool in
            return course.department == item
        }
        return filteredCourses
    }
    
    // Delete Items
    func deleteItems(items: [CourseUI]) {
        
        for item in items {
            // remove item
            let index = courses.indexOfObject(item)
            if index != -1 {
                courses.remove(at: index)
            }
        }
    }
    
}


extension Array {
    func indexOfObject<T:AnyObject>(_ item:T) -> Int {
        var index = -1
        for element in self {
            index += 1
            if item === element as? T {
                return index
            }
        }
        return index
    }
}
