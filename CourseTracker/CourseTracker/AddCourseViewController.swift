//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverControllerDelegate, SelectedCourses, CourseStoreDelegate {
    
    //temp info
    let data = CourseStore()
    
    //collectionview sections to collapse
    var sectionsToCollapse = [Int]()
    
    //popover view controller
    var popoverViewController : PopoverViewController?
    
    //array of selected courses
    var selectedArray = [Course]()
    
    //MARK: Properties
    @IBOutlet weak var calendarButton: UIButton!
    //collectionView
    @IBOutlet weak var courseCollectionView: UICollectionView!
    //tableView
    @IBOutlet weak var selectedTableView: UITableView!
    
    //searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    var dataSource:[String]?
    var dataSourceForSearchResult:[String]?
    var searchBarActive:Bool = false
    let courseStore = CourseStore()
    
    //default cell size
    let defaultItemSize = CGSize(width: 100, height: 100)
    
    //MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = courseStore
        courseStore.delegate = self
        
        self.dataSourceForSearchResult = [String]()
        
        selectedTableView.dataSource = self
        selectedTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = getIndexPathForSelectedCell(){
        }
    }
    
    //MARK: Tableview Helper Methods
    
    //MARK: Popover Delegate Method
    
    func didSelectCourse(course: Course){
        selectedArray.append(course)
        
        selectedTableView.reloadData()
    }
    
    //MARK: Tableview Delegate/ Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = selectedTableView.dequeueReusableCell(withIdentifier: "SelectedCourses") as! SelectedTableViewCell
        
        let selected = selectedArray[indexPath.row]
        
        cell.selectedCourseTitle.text = selected.name
        //add course to cell other wise
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
        var deletedCourses:[Course] = []
        
        let indexpaths = selectedTableView?.indexPathsForSelectedRows
        
        if let indexpaths = indexpaths {
            
            for item  in indexpaths {
                _ = selectedTableView!.cellForRow(at: item)
                
                selectedTableView?.deselectRow(at:item , animated: true)
                //courses for section
                let sectionCourse = data.coursesInGroup(item.section)
                deletedCourses.append(sectionCourse[item.row])
            }
            
            data.deleteItems(courses: deletedCourses)
            
            selectedTableView?.deleteRows(at: indexpaths, with: .none)
        }
    }
    
    
    //button that segues to Calendar
    @IBAction func calendarButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowCalendar", sender: sender)
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
        }else{
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
    
    //MARK: DataSource/ Delegate
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = courseCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! DepartmentCollectionReusableView
        //set the button to headers section and add an action
        headerView.button.tag = indexPath.section
        headerView.button.addTarget(self, action: #selector(headerBtnTapped(with:)), for: .touchUpInside )
        
        //set the text of the header Label
        headerView.departmentLabel.text = data.getGroupLabelAtIndex(indexPath.section)
        headerView.backgroundColor = .black
        
        return headerView
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.departments.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //search is active then
        if self.searchBarActive {
            return self.dataSourceForSearchResult!.count;
        }else{
            return data.numberOfRowsInEachGroup(section)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = courseCollectionView.dequeueReusableCell(withReuseIdentifier: "CourseIcon", for: indexPath) as! CourseCollectionViewCell
        //set the course data
        let courses = data.coursesInGroup(indexPath.section)
        
        let course = courses[indexPath.row]
        
        let name = course.code
        cell.courseLabel.text = name
        
        
        //implement search
        if (self.searchBarActive) {
            cell.courseLabel!.text = self.dataSourceForSearchResult![indexPath.row];
        }
        
        return cell
    }
    
    
    //call pop over as you select an item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let popover = self.storyboard?.instantiateViewController(withIdentifier: "Popover") as! PopoverViewController
        popover.course = courseStore.courseFor(indexPath: indexPath)
        popover.delegate = self
        self.present(popover, animated: true, completion: nil)
        
        courseCollectionView.reloadData()
    }
    
    //layout the collapsable headers
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //set sections size to zero if button is tapped
        if sectionsToCollapse.contains(indexPath.section) {
            return CGSize.zero
        }
        //if already collapsed then return to original size
        return defaultItemSize
    }
    
    func reloadData() {
        courseCollectionView.reloadData()
    }
    
}
