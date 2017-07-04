//
//  Models+Textbook.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-23.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import RealmSwift


final class TextbookMeetingSection: Object {
    dynamic var code = ""
    let instructors = List<RealmString>()

    convenience init?(fromJSON json: [String:Any]) {
        self.init()

        guard
            let code = json["code"] as? String,
            let instructors = json["instructors"] as? [String] else {
                print("JSON does not conform to TextbookMeetingSection Prototype JSON")
                return nil
        }

        self.code = code

        for instructor in instructors {
            self.instructors.append(RealmString(string: instructor))
        }
    }
}

final class TextbookCourse: Object {
    dynamic var id = ""
    dynamic var code = ""
    dynamic var requirement = ""
    let textbookMeetingSections = List<TextbookMeetingSection>()

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init?(fromJSON json: [String:Any]) {
        self.init()

        guard
            let id = json["id"] as? String,
            let code = json["code"] as? String,
            let requirement = json["requirement"] as? String,
            let _ = json["meeting_sections"] as? [[String:Any]] else {
                print("JSON does not conform to TextbookCourse Prototype JSON")
                return nil
        }

        self.id = id
        self.code = code
        self.requirement = requirement
    }
}

final class Textbook: Object {
    dynamic var id = ""
    dynamic var isbn = ""
    dynamic var title = ""
    dynamic var edition = -1
    dynamic var author = ""
    dynamic var imageURL = ""
    dynamic var price = 0.0
    dynamic var url = ""
    let courses = List<TextbookCourse>()

    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init?(fromJSON json: [String:Any]) {
        self.init()

        guard
            let id = json["id"] as? String,
            let isbn = json["isbn"] as? String,
            let title = json["title"] as? String,
            let edition = json["edition"] as? Int,
            let author = json["author"] as? String,
            let imageURL = json["image"] as? String,
            let price = json["price"] as? Double,
            let url = json["url"] as? String,
            let _ = json["courses"] as? [[String:Any]] else {
                print("JSON does not conform to Textbook Prototype JSON")
                return
        }

        self.id = id
        self.isbn = isbn
        self.title = title
        self.edition = edition
        self.author = author
        self.imageURL = imageURL
        self.price = price
        self.url = url
    }
}
