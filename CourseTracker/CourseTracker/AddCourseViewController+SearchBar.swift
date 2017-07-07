//
//  AddCourseViewController+SearchBar.swift
//  CourseTracker
//
//  Created by atfelix on 2017-07-07.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

extension AddCourseViewController: UISearchBarDelegate {
    
    func filterContentForSearchText(searchText: String) {
        CourseStore.filterDepartments(by: searchText)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBarActive = searchText.isEmpty
        self.filterContentForSearchText(searchText: searchText)
        self.courseCollectionView?.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearching()
        self.courseCollectionView?.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarActive = true
        self.view.endEditing(true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBarActive = false
        self.searchBar.setShowsCancelButton(false, animated: false)
    }

    func cancelSearching(){
        self.searchBarActive = false
        self.searchBar.resignFirstResponder()
        self.filterContentForSearchText(searchText: "")
        self.searchBar.text = ""
    }
}
