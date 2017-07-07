//
//  AddAthleticsViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-23.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

protocol AddAthleticsDelegate: class {
    func updateCalendarCell(for date: Date) -> Void
}

class AddAthleticsViewController: UIViewController {

    @IBOutlet weak var athleticTableView: UITableView!
    @IBOutlet weak var athleticCollectionView: UICollectionView!
    @IBOutlet weak var saveButton: UIButton!

    var date: Date!
    var athleticDate: AthleticDate? {
        get {
            let dateFormatter : DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            }()
            return realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: date ?? Date()))'").first
        }
    }
    var student: Student!
    var realm: Realm!
    var tableViewDataSource = [AthleticEvent]()

    weak var delegate: AddAthleticsDelegate?
}
