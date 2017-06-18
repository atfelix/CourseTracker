//
//  UofTAPI+Athletics.swift
//  CourseTracker
//
//  Created by atfelix on 2017-06-17.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import Foundation
import Alamofire

extension UofTAPI {

    static func makeAthleticsRequestURL(skip: Int, limit: Int = UofTAPI.maxLimit) -> URL? {
        return makeRequestURL(method: .athletics, skip: skip, limit: limit)
    }

    static func makeAthleticsRequest(skip: Int, limit: Int = UofTAPI.maxLimit) {

        let url = makeAthleticsRequestURL(skip: skip, limit: limit)
        Alamofire.request((url?.absoluteString)!).responseJSON { response in
            print(response.request!)
            print(response.response!)
            print(response.data!)
            print(response.result)
            print("================")

            if let JSON = response.result.value as? [[String:Any]], JSON.count > 0 {
                for event in JSON {
                    addOrUpdateEvent(fromJSON: event)
                }
                makeAthleticsRequest(skip: skip + limit, limit: limit)
            }
        }
    }

}
