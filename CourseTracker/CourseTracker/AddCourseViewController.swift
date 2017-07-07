//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

protocol AddCourseDelegate: class {
    func updateCalendar() -> Void
}

class AddCourseViewController: UIViewController {
    
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var courseCollectionView: UICollectionView!
    @IBOutlet weak var selectedTableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!

    var realm: Realm!
    var dataSource:[String]?
    var dataSourceForSearchResult:[CourseShortCode]?
    var searchBarActive:Bool = false
    var sectionsToCollapse = [Int]()
    var selectedArray = [Course]()
    var student: Student!
    var tableViewDidAnimate = false
    weak var delegate: AddCourseDelegate?
}
