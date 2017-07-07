//
//  AthleticCategory.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

struct AthleticCategory {
    static let categories = [AthleticCategory(category: "Gym", color: .red, imageName: "Gym"),
                             AthleticCategory(category: "Pool", color: .blue, imageName: "Pool"),
                             AthleticCategory(category: "Studio", color: .green, imageName: "Studio"),
                             AthleticCategory(category: "Fitness", color: .yellow, imageName: "Fitness"),
                             AthleticCategory(category: "Rock Climbing Wall", color: .orange, imageName: "Rock")]
    let category: String
    let color: UIColor
    let imageName: String

    private init(category: String, color: UIColor, imageName: String) {
        self.category = category
        self.color = color
        self.imageName = imageName
    }

    static func item(at index: Int) -> AthleticCategory? {
        guard 0 <= index && index < AthleticCategory.categories.count else { return nil }

        return AthleticCategory.categories[index]
    }
}
