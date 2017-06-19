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
    
    var courses:[Course] = []
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
                        
                        let course = Course(name: name, department: dept)
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
    func coursesInGroup(_ index: Int) -> [Course]{
        let item = departments[index]
        let filteredCourses = courses.filter { (course: Course) -> Bool in
            return course.department == item
        }
        return filteredCourses
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
