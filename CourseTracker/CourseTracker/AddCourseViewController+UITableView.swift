//
//  AddCourseViewController+UITableView.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension AddCourseViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard !tableViewDidAnimate else { return }

        let cellFrame = cell.frame
        cell.frame = CGRect(x: cellFrame.origin.x , y: tableView.frame.width, width: 0, height: 0)

        UIView.animate(withDuration: 1.0) {
            cell.frame = cellFrame
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            tableViewDidAnimate = true
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectedTableView.dequeueReusableCell(withIdentifier: "SelectedCourses") as! SelectedTableViewCell
        let selected = selectedArray[indexPath.row]
        cell.selectedCourseTitle.text = selected.name

        return cell
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArray.count
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try realm.write {
                    student.courses.remove(objectAtIndex: indexPath.row)
                }
                selectedArray.remove(at: indexPath.row)
            }
            catch let error {
                print("Realm write error: \(error.localizedDescription)")
                return
            }
            tableView.reloadData()
        }
    }
}
