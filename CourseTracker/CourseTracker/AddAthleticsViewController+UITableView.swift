//
//  AddAthleticsViewController+UITableView.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension AddAthleticsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let currentCell = tableView.cellForRow(at: indexPath) else { return }

        let athleticEvent = tableViewDataSource[indexPath.row]

        do {
            try realm.write {
                athleticEvent.studentAttending = !athleticEvent.studentAttending
            }
        }
        catch let error {
            print("Realm write error: \(error.localizedDescription)")
            return
        }

        let bgcolor = currentCell.backgroundColor
        currentCell.backgroundColor = .gray

        UIView.animate(withDuration: 0.4) {
            currentCell.accessoryType = (athleticEvent.studentAttending) ? .checkmark : .none
            currentCell.backgroundColor = bgcolor
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AthleticCell", for: indexPath) as! AthleticTableViewCell
        cell.athleticEvent = tableViewDataSource[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = (cell.athleticEvent.studentAttending) ? .checkmark : .none
        cell.update()
        
        return cell
    }
}
