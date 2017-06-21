//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, SelectedCourses, CourseStoreDelegate {
    
    // MARK: Properties

    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var courseCollectionView: UICollectionView!
    @IBOutlet weak var selectedTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var dataSource:[String]?
    var dataSourceForSearchResult:[String]?
    var searchBarActive:Bool = false
    var sectionsToCollapse = [Int]()
    var popoverViewController : PopoverViewController?
    var selectedArray = [Course]()

    let courseStore = CourseStore()
    
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        //search bar data
        searchBar.delegate = self
        self.dataSourceForSearchResult = [String]()
        
        //collectionview data
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = courseStore
        courseStore.delegate = self
        
        //table view data
        selectedTableView.dataSource = self
        selectedTableView.delegate = self
        selectedTableView.rowHeight = UITableViewAutomaticDimension
        selectedTableView.estimatedRowHeight = 28
        
    }
    // MARK: Popover Delegate

    func didSelectCourse(course: Course){
        selectedArray.append(course)
        selectedTableView.reloadData()
    }
    
    // MARK: Tableview Delegate / Datasource

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
    
    //MARK: Helper Methods
    
    //delete the course button
    @IBAction func deleteCourseTapped(_ sender: Any) {
        //
        var deletedCourses:[Course] = []

        if let indexPaths = selectedTableView?.indexPathsForSelectedRows {
            
            for indexPath  in indexPaths {
                _ = selectedTableView!.cellForRow(at: indexPath)
                
                selectedTableView?.deselectRow(at:indexPath , animated: true)
                deletedCourses.append(courseStore.courseFor(indexPath: indexPath)!)
            }
            
            courseStore.deleteItems(courses: deletedCourses)
            selectedTableView?.deleteRows(at: indexpaths, with: .none)
        }
        
    }
    //button that segues to Calendar
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowCalendar", sender: sender)
    }
    
    //button that collapses the header
    func headerBtnTapped(with button: UIButton){
        
        //rotate the button
        button.transform = button.transform.rotated(by: CGFloat.pi/2)
        
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
    func filterContentForSearchText(searchText:String){
        //        self.dataSourceForSearchResult = self.data.filter({ (text:String) -> Bool in
        //            return text.contains(searchText)
        //        })
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func reloadData() {
        courseCollectionView.reloadData()
    }
}
