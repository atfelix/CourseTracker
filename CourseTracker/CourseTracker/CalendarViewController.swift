//  CalendarViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-11.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: Properties
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    //Set colors of Calendar
    let outsideMonthColor = UIColor.gray
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor.black
    let currentDateSelectedViewColor = UIColor.cyan
    //Set date of Calendar
    let formatter = DateFormatter()
    
    //UserDate
    let userData = UserData()
    //Events
    var eventsAtCalendar = [Event]()
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup the tableView
        self.listTableView.backgroundColor = UIColor.black
        self.listTableView.separatorColor = UIColor.clear
        
        //setup the Calendar
        setupCalendarView()
        
        //Tap on Calendar
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCollectionView(gesture:)))
        doubleTapGesture.numberOfTapsRequired = 2  // add double tap
        calendarView.addGestureRecognizer(doubleTapGesture)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsAtCalendar.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as! ListTableViewCell
        var event = eventsAtCalendar[indexPath.row]
        //set Color if you want
        listTableView.backgroundColor = UIColor.black
        cell.backgroundColor = UIColor.black
        //set cells to user event data
        cell.listImage.backgroundColor = event.color
        cell.listData.text = event.title
        cell.listTime.text = "\(event.startDate)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: Calendar Helper Methods
    func didDoubleTapCollectionView(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        let cellState = calendarView.cellStatus(at: point)
        print(cellState!.date)
    }
    
    
    //handles the color schema
    func handleCellColor(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CalendarCell else {
            return
        }
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
        
        //setup labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        //year title
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        //month title
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
}
//MARK: Calendar DataSource Methods
extension CalendarViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        //configure calendar
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}
//MARK: Calendar Delegate Methods
extension CalendarViewController: JTAppleCalendarViewDelegate {
    //display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier:"CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellColor(view: cell, cellState: cellState)
        
        return cell
    }
    
    //select a cell
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellColor(view: cell, cellState: cellState)
        
        
        let eventsAtDate = userData.events?.filter({event -> Bool in
            let temp: Date = event.startDate as Date
            let isSameDay = Calendar.current.isDate(temp, equalTo: date, toGranularity: .day)
            return isSameDay
        })
        //if it exists
        if let filteredEvents = eventsAtDate{
            eventsAtCalendar = filteredEvents
            listTableView.reloadData()
        }
        //set user data at a certain date based on what courses they select
        //then show the courses in the table view
    }
    //deselect a cell
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellColor(view: cell, cellState: cellState)
    }
    //scroll to a new calendar page
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    
}
