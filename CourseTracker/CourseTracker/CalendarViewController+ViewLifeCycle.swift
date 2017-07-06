//
//  CalendarViewController+ViewLifeCycle.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-06.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar

extension CalendarViewController: AddAthleticsDelegate, AddCourseDelegate {

    // MARK: View setup
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
        addGestureRecognizers()
        setupListTableViewHeight()
        setupDateTappedLabel()
    }

    private func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.allowsMultipleSelection = false

        calendarView.visibleDates { [weak self] (visibleDates) in
            guard let welf = self else { return }
            welf.setupViewsOfCalendar(from: visibleDates)
        }
    }

    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        guard let date = visibleDates.monthDates.first?.date else { return }

        self.year.text = "\(Calendar.current.component(.year, from: date))"
        self.month.text = "\(DateFormatter().monthSymbols[Calendar.current.component(.month, from: date) - 1])"
    }

    private func addGestureRecognizers() {
        let swipeUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp(gesture:)))
        swipeUpGesture.direction = .up
        slidingView.addGestureRecognizer(swipeUpGesture)

        let swipeDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(gesture:)))
        swipeDownGesture.direction = .down
        slidingView.addGestureRecognizer(swipeDownGesture)

        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2
        calendarView.addGestureRecognizer(doubleTapGesture)
    }

    private func setupListTableViewHeight() {
        listTableView.estimatedRowHeight = 44.0
        listTableView.rowHeight = UITableViewAutomaticDimension
    }

    private func setupDateTappedLabel() {
        let displayDateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.medium
            return formatter
        }()
        self.dateTapped.text = "\(displayDateFormatter.string(from: calendarView.selectedDates.first ?? Date()))"
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCourse" {
            let addCourseVC = segue.destination as! AddCourseViewController
            addCourseVC.student = student
            addCourseVC.realm = realm
            addCourseVC.delegate = self
        }
        else if segue.identifier == "AddAthletics" {
            let addAthleticsVC = segue.destination as! AddAthleticsViewController
            addAthleticsVC.student = student
            addAthleticsVC.date = calendarView.selectedDates.first ?? Date()
            addAthleticsVC.realm = realm
            addAthleticsVC.delegate = self
        }
    }

    // MARK: Gesture Recognizers

    func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        guard let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowMap") as? MapViewController else {
            return
        }

        mapVC.realm = realm
        mapVC.student = student
        mapVC.date = calendarView.selectedDates.first ?? Date()
        self.present(mapVC, animated: true, completion: nil)
    }

    func didSwipeUp(gesture: UISwipeGestureRecognizer){
        UIView.animate(withDuration: 1.0) {
            self.viewHeightConstraint.constant += self.view.frame.height
            self.view.layoutIfNeeded()
        }
    }

    func didSwipeDown(gesture: UISwipeGestureRecognizer){
        UIView.animate(withDuration: 1.0) {
            self.viewHeightConstraint.constant -= self.view.frame.height
            self.view.layoutIfNeeded()
        }
    }

    // MARK: Additional Delegate methods

    func updateCalendarCell(for date: Date) {
        calendarView.reloadData()
        dismiss(animated: true, completion: nil)
    }

    func updateCalendar() {
        calendarView.reloadData()
        listTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
