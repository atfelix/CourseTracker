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

    static func makeTextbooksRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .textbooks, skip: skip, limit: limit)
    }

    static func makeTextbooksRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeTextbooksRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            print(response.result)
            print("================")

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for textbook in JSON {
                    addOrUpdateTextbook(fromJSON: textbook)
                }
                makeTextbooksRequest(skip: skip + limit, limit: limit)
            }
        }
    }

    static func addOrUpdateTextbook(fromJSON json: [String:Any]) {
        guard
            let id = json["id"] as? String,
            let isbn = json["isbn"] as? String,
            let title = json["title"] as? String,
            let edition = json["edition"] as? Int,
            let author = json["author"] as? String,
            let imageURL = json["image"] as? String,
            let price = json["price"] as? Double,
            let url = json["url"] as? String,
            let courses = json["courses"] as? [[String:Any]] else {
                print("JSON does not conform to Textbook Prototype JSON")
                return
        }

        let textbook = Textbook()
        textbook.id = id
        textbook.isbn = isbn
        textbook.title = title
        textbook.edition = edition
        textbook.author = author
        textbook.imageURL = imageURL
        textbook.price = price
        textbook.url = url

        for course in courses {
            addOrUpdateTextbookCourse(textbook: textbook, fromJSON: course)
        }

        try! realm.write {
            realm.add(textbook, update: true)
        }
    }

    static func addOrUpdateTextbookCourse(textbook: Textbook, fromJSON json: [String:Any]) {
        guard
            let id = json["id"] as? String,
            let code = json["code"] as? String,
            let requirement = json["requirement"] as? String,
            let meetingSections = json["meeting_sections"] as? [[String:Any]] else {
                print("JSON does not conform to TextbookCourse Prototype JSON")
                return
        }

        let textbookCourse = TextbookCourse()
        textbookCourse.id = id
        textbookCourse.code = code
        textbookCourse.requirement = requirement

        for meetingSection in meetingSections {
            addOrUpdateTextbookMeetingSection(textbookCourse: textbookCourse, fromJSON: meetingSection)
        }

        try! realm.write {
            textbook.courses.append(textbookCourse)
            realm.add(textbookCourse, update: true)
        }
    }

    static func addOrUpdateTextbookMeetingSection(textbookCourse: TextbookCourse, fromJSON json: [String:Any]) {
        guard
            let code = json["code"] as? String,
            let instructors = json["instructors"] as? [String] else {
                print("JSON does not conform to TextbookMeetingSection Prototype JSON")
                return
        }

        let textbookMeetingSection = TextbookMeetingSection()
        textbookMeetingSection.code = code

        for instructor in instructors {
            let realmString = RealmString()
            realmString.string = instructor
            textbookMeetingSection.instructors.append(realmString)
        }

        try! realm.write {
            textbookCourse.textbookMeetingSections.append(textbookMeetingSection)
            realm.add(textbookMeetingSection)
        }
    }
}
