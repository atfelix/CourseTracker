//
//  CalendarViewController+TableView.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-06.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import JTAppleCalendar

extension CalendarViewController: UITableViewDataSource, UITableViewDelegate {

    // MARK: Data source methods

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

        let courseEvents = student.coursesFor(day: dayOfWeek)
        athleticEvents = athleticEvents.sorted { $0.startTime < $1.startTime }

        let combinedEvents = mergeTimedEvents(courseEvents: courseEvents, athleticEvents: athleticEvents, for: dayOfWeek)

        cell.event = combinedEvents[indexPath.row]
        cell.update()

        return cell
    }

    // MARK: Delegate methods

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

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            redrawTableView = false
        }
    }

    // MARK: Helper methods

    private func mergeTimedEvents(courseEvents: [Course], athleticEvents: [AthleticEvent], for day: DaysOfWeek) -> [ListTableViewCellEvent] {
        var count = courseEvents.count + athleticEvents.count
        var courseIndex = 0
        var athleticEventIndex = 0
        var combinedEvents = [ListTableViewCellEvent]()

        while count > 0 {
            if athleticEventIndex == athleticEvents.count {
                combinedEvents.append(ListTableViewCellEvent(for: day, from: courseEvents[courseIndex]))
                courseIndex += 1
            }
            else if courseIndex == courseEvents.count {
                combinedEvents.append(ListTableViewCellEvent(from: athleticEvents[athleticEventIndex]))
                athleticEventIndex += 1
            }

            else if courseEvents[courseIndex].courseTimeFor(day: day).first!.startTime < athleticEvents[athleticEventIndex].startTime {
                combinedEvents.append(ListTableViewCellEvent(for: day, from: courseEvents[courseIndex]))
                courseIndex += 1
            }
            else {
                combinedEvents.append(ListTableViewCellEvent(from: athleticEvents[athleticEventIndex]))
                athleticEventIndex += 1
            }
            count -= 1
        }

        return combinedEvents
    }
}
