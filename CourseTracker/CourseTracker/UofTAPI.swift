//
//  UofTAPI.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-15.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

enum UofTError: Error {
    case invalidJSONData
}

enum Method: String {
    case courses = "/courses"
    case buildings = "/buildings"
    case textbooks = "/textbooks"
    case athletics = "/athletics"
    case parking = "/transportation/parking"
}

struct UofTAPI {
    private static let httpScheme = "https"
    private static let baseURLString = "cobalt.qas.im"
    private static let pathStart = "/api/1.0"
    private static let key = UNIVERSITY_OF_TORONTO_API_KEY

    static let realm = try! Realm()
    static let maxLimit = 100

    static func makeRequestURL(method: Method, skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        var components = URLComponents()
        components.scheme = UofTAPI.httpScheme
        components.host = UofTAPI.baseURLString
        components.path = UofTAPI.pathStart + method.rawValue
        components.queryItems = [URLQueryItem(name: "skip", value: "\(skip)"),
                                 URLQueryItem(name: "limit", value: "\(limit)"),
                                 URLQueryItem(name: "key", value: "\(UofTAPI.key)")]
        return components.url
    }
}
