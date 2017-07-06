//
//  CalendarViewController+JTAppleCalendar.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-06.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar

extension CalendarViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {

    //MARK: Calendar DataSource Methods

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {

        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()

        return ConfigurationParameters(startDate: Date(), endDate: dateFormatter.date(from: "2017 12 31")!, numberOfRows: 5, generateInDates:  .forAllMonths, generateOutDates: .tillEndOfRow, firstDayOfWeek: .sunday )
    }

    //MARK: Calendar Delegate Methods

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {

        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier:"CalendarCell", for: indexPath) as! CalendarCell

        defer {
            handleCellState(cell: cell, cellState: cellState, isToday: Calendar.current.compare(date, to: Date(), toGranularity: .day) == .orderedSame)
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

        handleCellState(cell: cell, cellState: cellState, isToday: false)

        self.dateTapped.text = "\(displayDateFormatter.string(from: calendarView.selectedDates.first ?? Date()))"
        listTableView.reloadData()
        redrawTableView = true

        addEventButton.isEnabled = self.athleticDate != nil

        UIView.animate(withDuration: 0.2, animations: {
            self.addEventButton.alpha = (self.addEventButton.isEnabled) ? 1.0 : 0.1
        })
    }

    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellState(cell: cell, cellState: cellState, isToday: false)
    }

    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }

    //MARK: Calendar Helper Methods

    private func handleCellColor(view: JTAppleCell?, cellState: CellState, isToday: Bool){
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

    private func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CalendarCell else {
            return
        }

        validCell.selectedView.isHidden = !validCell.isSelected
    }

    private func handleCellState(cell: JTAppleCell?, cellState: CellState, isToday: Bool) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellColor(view: cell, cellState: cellState, isToday: isToday)
    }
}
