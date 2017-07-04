//
//  UofTAPI+Textbook.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-17.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

extension UofTAPI {

    static func updateTextbookDB() {
        makeTextbooksRequest(skip: realm.objects(Textbook.self).count)
    }

    static func makeTextbooksRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .textbooks, skip: skip, limit: limit)
    }

    static func makeTextbooksRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeTextbooksRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            logResponseInfo(response: response)
            
            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for textbook in JSON {
                    addOrUpdateTextbook(fromJSON: textbook)
                }

                if JSON.count == limit {
                    sleep(5)
                    makeTextbooksRequest(skip: skip + limit, limit: limit)
                }
            }
        }
    }

    static func addOrUpdateTextbook(fromJSON json: [String:Any]) {
        guard
            let textbook = Textbook(fromJSON: json),
            let courses = json["courses"] as? [[String:Any]] else {
                print("JSON does not conform to Textbook Prototype JSON")
                return
        }

        for course in courses {
            addOrUpdateTextbookCourse(textbook: textbook, fromJSON: course)
        }

        do {
            try realm.write {
                realm.add(textbook, update: true)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }

    static func addOrUpdateTextbookCourse(textbook: Textbook, fromJSON json: [String:Any]) {
        guard
            let textbookCourse = TextbookCourse(fromJSON: json),
            let meetingSections = json["meeting_sections"] as? [[String:Any]] else {
                print("JSON does not conform to TextbookCourse Prototype JSON")
                return
        }

        for meetingSection in meetingSections {
            addOrUpdateTextbookMeetingSection(textbookCourse: textbookCourse, fromJSON: meetingSection)
        }

        do {
            try realm.write {
                textbook.courses.append(textbookCourse)
                realm.add(textbookCourse, update: true)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }

    static func addOrUpdateTextbookMeetingSection(textbookCourse: TextbookCourse, fromJSON json: [String:Any]) {
        guard let textbookMeetingSection = TextbookMeetingSection(fromJSON: json) else {
            print("JSON does not conform to TextbookMeetingSection Prototype JSON")
            return
        }

        do {
            try realm.write {
                textbookCourse.textbookMeetingSections.append(textbookMeetingSection)
                realm.add(textbookMeetingSection)
            }
        }
        catch let error {
            UofTAPI.logRealmError(error)
        }
    }
}
