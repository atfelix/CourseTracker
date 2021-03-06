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

    var realm: Realm!

    //MARK: Properties
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var dateTapped: UILabel!

    //TableView
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var slidingView: UIView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    //AddEvent
    @IBOutlet weak var addEvent: UIButton!
    //AddCourses
    @IBOutlet weak var addCourse: UIButton!

    //ChangeLayout
    @IBOutlet weak var changeLayout: UIButton!

    //Set colors of Calendar
    let outsideMonthColor = UIColor.gray
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor.black
    let currentDateSelectedViewColor = UIColor.cyan
    //Set date of Calendar
    let formatter = DateFormatter()
    let dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        let locale = Locale(identifier: "en_US_POSIX")
        formatter.locale = locale
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    let displayDateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        return formatter
    }()
    var firstDate : Date?
    var currentDate = Date()
    var cellStateChanged = false

    //UserDate
    let userData = UserData()
    //Events
    var eventsAtCalendar = [EventProtocol]()

    //Student
    var student: Student!
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup the Calendar
        setupCalendarView()
        
        //table constraints
        listTableView.estimatedRowHeight = 44.0
        listTableView.rowHeight = UITableViewAutomaticDimension

        //Swipe on Table to make it go up
        let swipeUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp(gesture:)))
        swipeUpGesture.direction = .up// add swipe down
        slidingView.addGestureRecognizer(swipeUpGesture)

        //Swipe on Table to make it go down
        let swipeDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(gesture:)))
        swipeDownGesture.direction = .down// add swipe down
        slidingView.addGestureRecognizer(swipeDownGesture)

        //Tap on Calendar Date to segue to daily route
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2  // add double tap
        calendarView.addGestureRecognizer(doubleTapGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Button Actions
    
    @IBAction func addEventTapped(_ sender: Any) {
        performSegue(withIdentifier: "AddEvent", sender: sender)
    }
    @IBAction func dropTableTapped(_ sender: Any) {

    }

    @IBAction func mapButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowMap", sender: sender)
    }

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
            let athleticDate = realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: calendarView.selectedDates.first ?? Date()))'")
            addAthleticsVC.athleticDate = realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: calendarView.selectedDates.first ?? Date()))'").first
            addAthleticsVC.realm = realm
            addAthleticsVC.delegate = self
        }
    }

    //Change background color of calendar
    @IBAction func changeLayoutTapped(_ sender: UIButton) {
        //take colors and put them into array and go through 1 by 1 when button is tapped
        self.calendarView.backgroundColor = UIColor.init(red: 200/255, green: 100/255, blue: 100/255, alpha: 1.0)

    }

    //This will change the layout to week view
    func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let cellState = calendarView.cellStatus(at: point)
        
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "ShowMap") as! MapViewController
        mapVC.realm = realm
        mapVC.student = student
        mapVC.date = calendarView.selectedDates.first ?? Date()
        self.present(mapVC, animated: true, completion: nil)
        
        print("Calculating Route for: \(cellState!.date)")
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

        guard cellStateChanged else { return }

        //set the cell.frame to a initial position outside the screen
        let cellFrame : CGRect = cell.frame
        
        //check the scrolling direction to verify from which side of the screen the cell should come
        let translation : CGPoint = tableView.panGestureRecognizer.translation(in: tableView.superview)
        //animate towards the desired final position
        if (translation.x > 0){
            cell.frame = CGRect(x: cellFrame.origin.x , y: tableView.frame.width, width: 0, height: 0)
        }else{
            cell.frame = CGRect(x: cellFrame.origin.x , y: tableView.frame.width, width: 0, height: 0)
        }

        UIView.animate(withDuration: 0.5) {
            cell.frame = cellFrame
        }

        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cellStateChanged = false
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

        guard let athleticDate = realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: selectedDate))'").first else {
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

        if let athleticDate = realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: selectedDate))'").first {
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
            cell.listView.backgroundColor = UIColor.init(red: 102/255, green: 0/255, blue: 0/255, alpha: 0.20)
            cell.listLocation.text = "\(event.campus): \(event.location)"
            cell.listData.text = event.title
            cell.listTime.numberOfLines = 0
            cell.listTime.text = "\(event.startTime.convertSecondsFromMidnight())\n\(event.endTime.convertSecondsFromMidnight())"
        }
        else if athleticEventIndex == athleticEvents.count {
            courseIndex += count
            let course = courses[courseIndex]
            cell.listImage.image = UIImage(named: "ic_account_balance_white")
            cell.listView.backgroundColor = UIColor.init(red: 191/255, green: 150/255, blue: 94/255, alpha: 0.15)
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
            cell.listView.backgroundColor = UIColor.init(red: 191/255, green: 150/255, blue: 94/255, alpha: 0.15)
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
            cell.listView.backgroundColor = UIColor.init(red: 102/255, green: 0/255, blue: 0/255, alpha: 0.20)
            cell.listLocation.text = "\(event.campus): \(event.location)"
            cell.listData.text = event.title
            cell.listTime.numberOfLines = 0
            cell.listTime.text = "\(event.startTime.convertSecondsFromMidnight())\n\(event.endTime.convertSecondsFromMidnight())"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            cellStateChanged = false
        }
    }

    //select item
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

    //MARK: Calendar Helper Methods

    //handles the color schema
    func handleCellColor(view: JTAppleCell?, cellState: CellState, isToday: Bool){
        guard let validCell = view as? CalendarCell else {
            return
        }
        validCell.selectedView.isHidden = !cellState.isSelected
        //if cell is today cell
        if isToday{
            validCell.todayView.isHidden = false
            validCell.todayView.backgroundColor = UIColor.black
            return
        }

        //if cell is selected change color
        if cellState.isSelected{
            validCell.selectedView.isHidden = false
            validCell.dateLabel.textColor = selectedMonthColor
        }else{
            validCell.selectedView.isHidden = true
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
            }else{
                validCell.dateLabel.textColor = outsideMonthColor
            }
        }
    }

    //if cell is selected, show selection
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CalendarCell else {
            return
        }
        if validCell.isSelected{
            validCell.selectedView.isHidden = false
        }else{
            validCell.selectedView.isHidden = true
        }

    }

    func setupCalendarView(){
        //setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.allowsMultipleSelection = false

        //setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }

    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        //year title
        formatter.dateFormat = "yyyy"
        self.year.text = formatter.string(from: date)
        //month title
        formatter.dateFormat = "MMMM"
        self.month.text = formatter.string(from: date)
    }

    //MARK: Calendar DataSource Methods

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        let startDate = dateFormatter.date(from: "2017 06 01")!
        let endDate = dateFormatter.date(from: "2017 12 31")!

        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 5, generateInDates:  .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: .sunday )
        return parameters
    }

    //MARK: Calendar Delegate Methods
    //display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier:"CalendarCell", for: indexPath) as! CalendarCell

        defer {
            handleCellSelected(view: cell, cellState: cellState)
            handleCellColor(view: cell, cellState: cellState, isToday: Calendar.current.compare(date, to: currentDate, toGranularity: .day) == .orderedSame)
        }

        cell.dateLabel.text = cellState.text


        //set the courseLabel indicator to yellow or silver for different events

        if student.coursesFor(day: cellState.day).count > 0 {
            cell.coursesLabel.backgroundColor =  UIColor.init(red: 191/255, green: 150/255, blue: 94/255, alpha: 1)
            cell.coursesLabel.layer.cornerRadius = 2.5
            cell.coursesLabel.layer.masksToBounds = true
        }
        else {
            cell.coursesLabel.backgroundColor = .clear
        }

        cell.customLabel.backgroundColor = .clear

        if let athleticDate = realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: date))'").first {

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

    //select a cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {

        handleCellSelected(view: cell, cellState: cellState)

        handleCellColor(view: cell, cellState: cellState, isToday: false)


        let eventsAtDate = userData.events?.filter({event -> Bool in
            let temp: Date = event.startDate as Date
            let isSameDay = Calendar.current.isDate(temp, equalTo: date, toGranularity: .day)
            return isSameDay
        })
        //if it exists then filter events and reload table
        if let filteredEvents = eventsAtDate{
            eventsAtCalendar = filteredEvents
            listTableView.reloadData()
        }
        //set the current date
        let selectedDates = calendarView.selectedDates
        if firstDate == nil{
            self.dateTapped.text = "\(displayDateFormatter.string(from: selectedDates.first!))"
        }

        cellStateChanged = true

        let count = realm.objects(AthleticDate.self).filter("date == '\(dateFormatter.string(from: date))'").count
        addEvent.isEnabled = count != 0

        UIView.animate(withDuration: 0.2, animations: {
            self.addEvent.alpha = (self.addEvent.isEnabled) ? 1.0 : 0.1
        })
    }

    //deselect a cell
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellColor(view: cell, cellState: cellState, isToday: false)
    }
    //scroll to a new calendar page
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
