//
//  CourseTableViewCell.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-12.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import Foundation

class CourseTableViewCell {
    
    //Set Items in tableView
    var items = [Item]()
    
    class Item {
        var isHidden: Bool
        var value: String
        var isChecked: Bool
        
        init(_ hidden: Bool = true, value: String, checked: Bool = false) {
            self.isHidden = hidden
            self.value = value
            self.isChecked = checked
        }
    }
    
    //MARK: Table Cell Helper methods
    class HeaderItem: Item {
        init (value: String) {
            super.init(false, value: value, checked: false)
        }
    }
    
    func append(_ item: Item) {
        self.items.append(item)
    }
    
    func removeAll() {
        self.items.removeAll()
    }
    
    func expand(_ headerIndex: Int) {
        self.toogleVisible(headerIndex, isHidden: false)
    }
    
    func collapse(_ headerIndex: Int) {
        self.toogleVisible(headerIndex, isHidden: true)
    }
    
    private func toogleVisible(_ headerIndex: Int, isHidden: Bool) {
        var headerIndex = headerIndex
        headerIndex += 1
        
        while headerIndex < self.items.count && !(self.items[headerIndex] is HeaderItem) {
            self.items[headerIndex].isHidden = isHidden
            
            headerIndex += 1
        }
    }
    
}
