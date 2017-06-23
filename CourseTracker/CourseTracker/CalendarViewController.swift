//  CalendarViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-11.
//  Copyright © 2017 Adam Felix. All rights reserved.
//
import UIKit
import JTAppleCalendar
import RealmSwift

import IBAnimatable

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{

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

    //UserDate
    let userData = UserData()
    //Events
    var eventsAtCalendar = [EventProtocol]()

    //Student
    var student: Student!
    
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Animations

        //setup the tableView
        self.listTableView.backgroundColor = UIColor.black
        self.listTableView.separatorColor = UIColor.lightGray

        //setup the Calendar
        setupCalendarView()

        //Swipe on Table to make it go up
        let swipeUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeUp(gesture:)))
        swipeUpGesture.direction = .up// add swipe down
        slidingView.addGestureRecognizer(swipeUpGesture)

        //Swipe on Table to make it go down
        let swipeDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeDown(gesture:)))
        swipeDownGesture.direction = .down// add swipe down
        slidingView.addGestureRecognizer(swipeDownGesture)

        //Tap on Calendar to change View
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
//    @IBAction func addCourseTapped(_ sender: Any) {
//        performSegue(withIdentifier: "AddCourse", sender: sender)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
            if segue.identifier == "AddCourse" {
                let addCourseVC = segue.destination as! AddCourseViewController
                addCourseVC.student = student
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
        print(cellState!.date)
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
    
    //tableview animation
    //animation method
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
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
        
        UIView.animate(withDuration: 1.0) {
            cell.frame = cellFrame
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.courses.count
    }

    //set data in table row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! ListTableViewCell
//        var event = eventsAtCalendar[indexPath.row]
        //set Color if you want
        listTableView.backgroundColor = UIColor.black
        cell.backgroundColor = UIColor.black
        //set cells to user event data
//        cell.listImage.backgroundColor = event.color
//        cell.listLocation.text = event.location
//        cell.listData.text = event.title
//        cell.listTime.text = "\(event.startDate) - \(event.endDate)"
        
        let course = student.courses[indexPath.row]
        cell.listImage.backgroundColor =  UIColor.init(red: 255/255, green: 215/255, blue: 0/255, alpha: 1)
        cell.listLocation.text = course.campus
        cell.listData.text = course.name
        cell.listTime.text = "NO TIME YET"

        return cell
    }
    //select item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

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
        //sets datelabel to current cell state
        cell.dateLabel.text = cellState.text

        
        //date -> ?
        
        print(dateFormatter.string(from: currentDate))
        
        //set the courseLabel indicator to yellow or silver for different events
        
        if CourseEvent.self != nil {
            cell.coursesLabel.backgroundColor = UIColor.yellow
            cell.coursesLabel.layer.cornerRadius = 2.5
            cell.coursesLabel.layer.masksToBounds = true
        }
        if CustomEvent.self != nil{
            cell.customLabel.backgroundColor = UIColor.lightGray
            cell.customLabel.layer.cornerRadius = 2.5
            cell.customLabel.layer.masksToBounds = true
        }


        handleCellSelected(view: cell, cellState: cellState)
        //if today else
        if dateFormatter.string(from: date) == dateFormatter.string(from: currentDate){
            handleCellColor(view: cell, cellState: cellState, isToday: true)
        }else{
            handleCellColor(view: cell, cellState: cellState, isToday: false)
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

}
