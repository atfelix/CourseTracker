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
    static let httpScheme = "https"
    static let baseURLString = "cobalt.qas.im"
    static let pathStart = "/api/1.0"
    static let key = UNIVERSITY_OF_TORONTO_API_KEY
    static let maxLimit = 100

    private static let config = Realm.Configuration(shouldCompactOnLaunch: { totalBytes, usedBytes in
        return true
    })
    static let realm = try! Realm(configuration: config)

    static func updateDB() {
        updateAthleticDB()
        updateBuildingDB()
        updateTextbookDB()
        updateParkingDB()
        updateCourseDB()

        if realm.objects(CourseShortCode.self).count == 0 {
            createCouseShortCodeinDB()
        }

        //guard let shortCode = realm.objects(CourseShortCode.self).filter("shortCode == 'AST'").first else { print("blah"); return}
        let courses = realm.objects(Course.self).filter("term BEGINSWITH '2017 Summer'")
        for course in courses {
            print(course.code, course.name)
        }
    }

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

    static func logRealmError(_ error: Error) {
        print("Realm write error: \(error.localizedDescription)")
    }
}
