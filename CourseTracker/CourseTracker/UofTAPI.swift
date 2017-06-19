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

enum FilterQueryType: String {
    case Equal = ""
    case NotEqual = "!"
    case LessThan = "<"
    case GreaterThan = ">"
    case LessThanOrEqual = "<="
    case GreaterThanOrEqual = ">="
}

struct UofTAPI {
    static let httpScheme = "https"
    static let baseURLString = "cobalt.qas.im"
    static let pathStart = "/api/1.0"
    static let key = UNIVERSITY_OF_TORONTO_API_KEY

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

    static func makeRequestFilterURL(method: Method, filterParameters: [String:String]?, skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {

        guard let filterParameters = filterParameters, filterParameters.count > 0 else {
            print("Filter parameters must have query types")
            return nil
        }

        var components = URLComponents()
        components.scheme = UofTAPI.httpScheme
        components.host = UofTAPI.baseURLString
        components.path = UofTAPI.pathStart + method.rawValue

        guard var urlString = components.url?.absoluteString else { return nil }

        urlString += "/filter?q="


        return URL(string: urlString)
    }

    static func updateDB() {

    }
}
