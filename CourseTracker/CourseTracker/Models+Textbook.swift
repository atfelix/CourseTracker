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
}

final class TextbookCourse: Object {
    dynamic var id = ""
    dynamic var code = ""
    dynamic var requirement = ""
    let textbookMeetingSections = List<TextbookMeetingSection>()

    override static func primaryKey() -> String? {
        return "id"
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
}
