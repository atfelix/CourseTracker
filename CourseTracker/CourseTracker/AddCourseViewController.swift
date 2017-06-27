//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit
import RealmSwift
import Foundation

class AddCourseViewController: UIViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, SelectedCourses, CourseStoreDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var courseCollectionView: UICollectionView!
    @IBOutlet weak var selectedTableView: UITableView!
    @IBOutlet weak var tableHeaderView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var dataSource:[String]?
    var dataSourceForSearchResult:[String]?
    var searchBarActive:Bool = false
    var sectionsToCollapse = [Int]()
    var popoverViewController : PopoverViewController?
    var selectedArray = [Course]()
    var student: Student!
    var realm: Realm!
    
    let courseStore = CourseStore()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Student
        realm = try! Realm()
        
        selectedArray = Array(student.courses)
        
        //SearchBar
        searchBar.delegate = self
        self.dataSourceForSearchResult = [String]()
        
        //collectionview data
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = courseStore
        courseStore.delegate = self
        
        //table view data
        selectedTableView.dataSource = self
        selectedTableView.delegate = self
        
        selectedTableView.estimatedRowHeight = 40.0
        selectedTableView.rowHeight = UITableViewAutomaticDimension
        
        //layouts
        calendarButton.layer.cornerRadius = 4
    }
    // MARK: Popover Delegate
    
    func didSelectCourse(course: Course){
        
        defer {
            self.dismiss(animated: true, completion: nil)
            selectedTableView.reloadData()
        }
        
        selectedArray.append(course)
        
        do {
            try realm.write{
                student.courses.append(course)
            }
        }
        catch let error {
            print("Realm write error: \(error.localizedDescription)")
            return
        }
    }
    
    func didCancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Tableview Delegate / Datasource
    
    //animation method
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //set the cell.frame to a initial position outside the screen
        let cellFrame : CGRect = cell.frame
        
        //check the scrolling direction to verify from which side of the screen the cell should come
        let translation : CGPoint = tableView.panGestureRecognizer.translation(in: tableView.superview)
        //animate towards the desired final position
        if (translation.x > 0){
            cell.frame = CGRect(x: cellFrame.origin.x , y: tableView.frame.width, width: 0, height: 0)
        }else{
            cell.frame = CGRect(x: cellFrame.origin.x , y: tableView.frame.width, width: 0, height: 0)
        }
        
        UIView.animate(withDuration: 1.0) {
            cell.frame = cellFrame
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = selectedTableView.dequeueReusableCell(withIdentifier: "SelectedCourses") as! SelectedTableViewCell
        let selected = selectedArray[indexPath.row]
        cell.selectedCourseTitle.text = selected.name
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedArray.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedArray.remove(at: indexPath.row)
            try! realm.write {
                student.courses.remove(objectAtIndex: indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
    //MARK: Helper Methods
    
    //button that segues to Calendar
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "ShowCalendar", sender: sender)
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCalendar" {
            
            let calendarVC = segue.destination as! CalendarViewController
            calendarVC.student = student
        }
    }
    
    //button that collapses the header
    func headerBtnTapped(with button: UIButton){
        
        //get header index
        guard let index = sectionsToCollapse.index(of: button.tag) else {
            sectionsToCollapse.append(button.tag)
            courseCollectionView.reloadData()
            return
        }
        //remove header from Sections to Collapse
        sectionsToCollapse.remove(at: index)
        courseCollectionView.reloadData()
        
    }
    
    //get indexpath of selected cell
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath: IndexPath?
        
        if courseCollectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = courseCollectionView.indexPathsForSelectedItems![0]
        }
        return indexPath
    }
    
    //MARK: SearchBar
    
//    func filterContentForSearchText(searchText:String){
//        self.dataSourceForSearchResult = self.courseStore.departments.filter({ (text:String) -> Bool in
//            return text.contains(searchText)
//        })
//    }
    
    //search function
    func filterContentForSearchText(searchText: String) {
//        
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchText)
//        
//        let array = (self.courseStore.courses as NSArray).filtered(using: searchPredicate)
//        self.dataSourceForSearchResult = array as? [String]
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.searchBarActive    = true
            self.filterContentForSearchText(searchText: searchText)
            self.courseCollectionView?.reloadData()
        }
        else {
            self.searchBarActive = false
            self.courseCollectionView?.reloadData()
        }
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
        self.searchBar.text = ""
    }
    
    //MARK: Collectionview helper methods
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        return CGSize(width: 100, height: 100)
    //    }
    func reloadData() {
        courseCollectionView.reloadData()
    }
}
