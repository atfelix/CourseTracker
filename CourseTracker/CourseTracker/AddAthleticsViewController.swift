//
//  AddAthleticsViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-23.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift

class AddAthleticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var athleticTableView: UITableView!
    var date: Date!
    var athleticDate: AthleticDate!
    var student: Student!

    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
        print(dateFormatter.string(from: date))

        athleticDate = try! Realm().objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: date))'").first!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return athleticDate.athleticEvents.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AthleticCell", for: indexPath) as! AthleticTableViewCell
        cell.athleticEvent = athleticDate.athleticEvents.sorted(byKeyPath: "startTime")[indexPath.row]
        cell.update()
        return cell
    }
}
