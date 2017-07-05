//
//  CalendarViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-11.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RealmSwift

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, AddAthleticsDelegate, AddCourseDelegate {

    // MARK: Properties

    // MARK: Passed in properties

    var realm: Realm!
    var student: Student!

    // MARK: UI Properties

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var dateTapped: UILabel!

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var slidingView: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var addEventButton: UIButton!
    @IBOutlet weak var addCourseButton: UIButton!

    var athleticDate: AthleticDate? {
        get {
            let dateFormatter : DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter
            }()
            return realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: calendarView.selectedDates.first ?? Date()))'").first
        }
    }

    var redrawTableView = false
    
    
    // MARK: View life cycle

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

    private func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
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

    //MARK: Button Actions

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

    //MARK: TableView Methods
    
    //animation method
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard redrawTableView else { return }

        let cellFrame : CGRect = cell.frame
        cell.frame = CGRect(x: cellFrame.origin.x , y: tableView.frame.width, width: 0, height: 0)

        UIView.animate(withDuration: 0.5) {
            cell.frame = cellFrame
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            redrawTableView = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard
            let selectedDate = calendarView.selectedDates.first,
            let dayOfWeek = DaysOfWeek(rawValue: selectedDate.dayOfWeek) else {
                return 0
        }

        var count = student.coursesFor(day: dayOfWeek).count

        guard let athleticDate = self.athleticDate else {
            return count
        }

        for event in athleticDate.athleticEvents {
            if event.studentAttending {
                count += 1
            }
        }
        
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! ListTableViewCell
        
        guard
            let selectedDate = calendarView.selectedDates.first,
            let dayOfWeek = DaysOfWeek(rawValue: selectedDate.dayOfWeek)else {
                return cell
        }

        var athleticEvents = [AthleticEvent]()

        if let athleticDate = self.athleticDate {
            for event in athleticDate.athleticEvents {
                if event.studentAttending {
                    athleticEvents.append(event)
                }
            }
        }

        let courses = student.coursesFor(day: dayOfWeek)
        athleticEvents = athleticEvents.sorted { $0.startTime < $1.startTime }

        var count = indexPath.row
        var courseIndex = 0
        var athleticEventIndex = 0

        while count > 0 && courseIndex < courses.count && athleticEventIndex < athleticEvents.count {
            if courses[courseIndex].courseTimeFor(day: dayOfWeek).first!.startTime < athleticEvents[athleticEventIndex].startTime {
                courseIndex += 1
            }
            else {
                athleticEventIndex += 1
            }
            count -= 1
        }

        if courseIndex == courses.count {
            athleticEventIndex += count
            let event = athleticEvents[athleticEventIndex]
            cell.listImage.image = UIImage(named: "ic_pool_white")
            cell.listView.backgroundColor = UIColor.init(red: 102/255, green: 0/255, blue: 0/255, alpha: 0.10)
            cell.listLocation.text = "\(event.campus): \(event.location)"
            cell.listData.text = event.title
            cell.listTime.numberOfLines = 0
            cell.listTime.text = "\(event.startTime.convertSecondsFromMidnight())\n\(event.endTime.convertSecondsFromMidnight())"
        }
        else if athleticEventIndex == athleticEvents.count {
            courseIndex += count
            let course = courses[courseIndex]
            cell.listImage.image = UIImage(named: "ic_account_balance_white")
            cell.listView.backgroundColor = UIColor.init(red: 191/255, green: 150/255, blue: 94/255, alpha: 0.10)
            cell.listLocation.text = "\(course.campus)"
            cell.listData.text = course.name
            cell.listTime.numberOfLines = 0

            if let firstTime = course.courseTimeFor(day: dayOfWeek).first {
                cell.listTime.text = "\(firstTime.startTime.convertSecondsFromMidnight())\n\(firstTime.endTime.convertSecondsFromMidnight())"
            }
        }
        else if courses[courseIndex].courseTimeFor(day: dayOfWeek).first!.startTime < athleticEvents[athleticEventIndex].startTime {
            let course = courses[courseIndex]
            cell.listImage.image = UIImage(named: "ic_account_balance_white")
            cell.listView.backgroundColor = UIColor.init(red: 191/255, green: 150/255, blue: 94/255, alpha: 0.10)
            cell.listLocation.text = "\(course.campus)"
            cell.listData.text = course.name
            cell.listTime.numberOfLines = 0

            if let firstTime = course.courseTimeFor(day: dayOfWeek).first {
                cell.listTime.text = "\(firstTime.startTime.convertSecondsFromMidnight())\n\(firstTime.endTime.convertSecondsFromMidnight())"
            }
        }
        else {
            let event = athleticEvents[athleticEventIndex]
            cell.listImage.image = UIImage(named: "ic_pool_white")
            cell.listView.backgroundColor = UIColor.init(red: 102/255, green: 0/255, blue: 0/255, alpha: 0.10)
            cell.listLocation.text = "\(event.campus): \(event.location)"
            cell.listData.text = event.title
            cell.listTime.numberOfLines = 0
            cell.listTime.text = "\(event.startTime.convertSecondsFromMidnight())\n\(event.endTime.convertSecondsFromMidnight())"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            redrawTableView = false
        }
    }

    //MARK: Calendar Helper Methods

    func handleCellColor(view: JTAppleCell?, cellState: CellState, isToday: Bool){
        guard let validCell = view as? CalendarCell else {
            return
        }

        validCell.selectedView.isHidden = !cellState.isSelected

        if isToday {
            validCell.todayView.isHidden = false
            validCell.todayView.backgroundColor = UIColor.black
        }
        else if cellState.isSelected {
            validCell.dateLabel.textColor = selectedMonthColor
        }
        else {
            validCell.dateLabel.textColor = (cellState.dateBelongsTo == .thisMonth) ? monthColor : outsideMonthColor
        }
    }

    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CalendarCell else {
            return
        }

        validCell.selectedView.isHidden = !validCell.isSelected
    }

    //MARK: Calendar DataSource Methods

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()

        let parameters = ConfigurationParameters(startDate: Date(), endDate: dateFormatter.date(from: "2017 12 31")!, numberOfRows: 5, generateInDates:  .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: .sunday )
        return parameters
    }

    //MARK: Calendar Delegate Methods

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier:"CalendarCell", for: indexPath) as! CalendarCell

        defer {
            handleCellSelected(view: cell, cellState: cellState)
            handleCellColor(view: cell, cellState: cellState, isToday: Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame)
        }

        cell.dateLabel.text = cellState.text

        if student.coursesFor(day: cellState.day).count > 0 {
            cell.coursesLabel.backgroundColor =  UIColor.init(red: 191/255, green: 150/255, blue: 94/255, alpha: 1)
            cell.coursesLabel.layer.cornerRadius = 2.5
            cell.coursesLabel.layer.masksToBounds = true
        }
        else {
            cell.coursesLabel.backgroundColor = .clear
        }

        cell.customLabel.backgroundColor = .clear

        if let athleticDate = self.athleticDate {

            for event in athleticDate.athleticEvents {
                if event.studentAttending {
                    cell.customLabel.backgroundColor = UIColor.init(red: 102/255, green: 0/255, blue: 0/255, alpha: 1)
                    cell.customLabel.layer.cornerRadius = 2.5
                    cell.customLabel.layer.masksToBounds = true
                    break
                }
            }
        }
        return cell
    }

    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {

        let displayDateFormatter : DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.medium
            return formatter
        }()

        handleCellSelected(view: cell, cellState: cellState)
        handleCellColor(view: cell, cellState: cellState, isToday: false)
        redrawTableView = true

        self.dateTapped.text = "\(displayDateFormatter.string(from: calendarView.selectedDates.first ?? Date()))"
        listTableView.reloadData()

        addEventButton.isEnabled = self.athleticDate != nil

        UIView.animate(withDuration: 0.2, animations: {
            self.addEventButton.alpha = (self.addEventButton.isEnabled) ? 1.0 : 0.1
        })
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellColor(view: cell, cellState: cellState, isToday: false)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }

    func updateCalendarCell(for date: Date) {
        calendarView.reloadData()
        listTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }

    func updateCalendar() {
        calendarView.reloadData()
        listTableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}
