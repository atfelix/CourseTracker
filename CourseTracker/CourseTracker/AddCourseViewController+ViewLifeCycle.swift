//
//  AddCourseViewController+ViewLifeCycle.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension AddCourseViewController: SelectedCourses, CourseStoreDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSearchBar()
        setupCollectionView()
        setupTableView()
        setupCalendarButton()
    }

    private func setupSearchBar() {
        searchBar.delegate = self
        self.dataSourceForSearchResult = [CourseShortCode]()
    }

    private func setupCollectionView() {
        courseCollectionView.delegate = self
        CourseStore.realm = realm
        courseCollectionView.dataSource = CourseStore.shared
        CourseStore.delegate = self
    }

    private func setupTableView() {
        selectedArray = Array(student.courses)
        selectedTableView.dataSource = self
        selectedTableView.delegate = self
        selectedTableView.estimatedRowHeight = 40.0
        selectedTableView.rowHeight = UITableViewAutomaticDimension
    }

    private func setupCalendarButton() {
        calendarButton.layer.cornerRadius = 4
    }

    // MARK: Selected Courses delegate methods

    func didSelectCourse(course: Course){

        defer {
            self.dismiss(animated: true, completion: nil)
            let indexPath = IndexPath(row: selectedArray.count - 1, section: 0)
            selectedTableView.insertRows(at: [indexPath], with: .middle)
        }

        selectedArray.append(course)

        do {
            try realm.write{
                student.courses.append(course)
            }
        }
        catch let error {
            print("Realm write error: \(error.localizedDescription)")
            return
        }
    }

    func didCancel() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: Course Store delegate methods

    func reloadData() {
        courseCollectionView.reloadData()
    }

    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        delegate?.updateCalendar()
    }
}
