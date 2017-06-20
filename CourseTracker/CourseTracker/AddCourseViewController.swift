//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource{
    
    //temp info
    let data = DataSource()
    //collectionview sections to collapse
    var sectionsToCollapse = [Int]()
    
    //popover view controller
    var popoverViewController : PopoverViewController?
    //array of selected courses
    var selectedArray = [CourseUI]()
    
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
    
    //default cell size
    let defaultItemSize = CGSize(width: 100, height: 100)
    
    //MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        courseCollectionView.delegate = self
        courseCollectionView.dataSource = self
        
        self.dataSourceForSearchResult = [String]()
        
        selectedTableView.dataSource = self
        selectedTableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let indexPath = getIndexPathForSelectedCell(){
            highlightCell(indexPath, flag: false)
        }
    }
    //MARK: Tableview Helper Methods
    func selectedCourses() {
        //1) Create an array.
        //2) Add selected items to array.
        //3) Once done, populate your tableview from the array.
        
        
        //        let course = tempCourse[indexPath.row].it?.date!
        //
        //
        //        for item in 0..<collection.numberOfItemsInSection(0) {
        //
        //            let myPath = NSIndexPath(forRow: item, inSection: 0)
        //            let partecipant = partecipantsAtEvent[myPath.row].date!
        //
        //
        //            if price == partecipant {
        //
        //                selectedArray.append(partecipant)
        //            }
        //
        //        }
    }
    
    
    
    //MARK: Tableview Delegate/ Datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = selectedTableView.dequeueReusableCell(withIdentifier: "SelectedCourses") as? SelectedTableViewCell{
            
            let selected = selectedArray[indexPath.row]
            
            cell.selectedCourseTitle.text = selected.name
            //add course to cell other wise
            return cell
        } else {
            //return the tableview cell
            return SelectedTableViewCell()
        }
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
            var deletedCourses:[CourseUI] = []
            
            let indexpaths = courseCollectionView?.indexPathsForSelectedItems
            
            if let indexpaths = indexpaths {
                
                for item  in indexpaths {
                    _ = courseCollectionView!.cellForItem(at: item)
    
                    courseCollectionView?.deselectItem(at:item , animated: true)
                    //courses for section
                    let sectionCourse = data.coursesInGroup(item.section)
                    deletedCourses.append(sectionCourse[item.row])
                }
                
                data.deleteItems(items: deletedCourses)
                
                courseCollectionView?.deleteItems(at: indexpaths)
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
    //when cell is selected
    func highlightCell(_ indexPath : IndexPath, flag: Bool) {
        
        let cell = courseCollectionView.cellForItem(at: indexPath)
        
        if flag {
            cell?.contentView.backgroundColor = .black
            //initialize pop up view controller
        } else {
            cell?.contentView.backgroundColor = .clear
        }
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
        self .cancelSearching()
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
        let courses: [CourseUI] = data.coursesInGroup(indexPath.section)
        let course = courses[indexPath.row]
        
        let name = course.name!
        cell.courseLabel.text = name.capitalized
        
        
        //implement search
        if (self.searchBarActive) {
            cell.courseLabel!.text = self.dataSourceForSearchResult![indexPath.row];
        }
        
        return cell
    }
    
    
    //call pop over as you select an item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let popover = self.popoverViewController {
            
            let cell = self.courseCollectionView!.cellForItem(at: indexPath) as! CourseCollectionViewCell
            popover.popCourseLabel.text = cell.courseLabel.text
            
        }
        else {
            
            self.popoverViewController = self.storyboard?.instantiateViewController(withIdentifier: "Popover") as? PopoverViewController
            
            let cell = self.courseCollectionView!.cellForItem(at: indexPath) as! CourseCollectionViewCell
            
            _ = self.popoverViewController!.view
            self.popoverViewController!.popCourseLabel.text = cell.courseLabel.text
            //set description
            //set textbooks
            
            self.popoverViewController!.modalPresentationStyle = .overCurrentContext
            let popover = self.popoverViewController!.popoverPresentationController
            
            
            popover?.passthroughViews = [self.view]
            popover?.sourceRect = CGRect(x: UIScreen.main.bounds.width * 0.5 - 200, y: UIScreen.main.bounds.height * 0.5 - 100, width: 242, height: 174)
            
            popover?.sourceView = self.view

            self.popoverViewController!.preferredContentSize = CGSize(width: 242, height: 174)
            
            self.present(self.popoverViewController!, animated: true, completion: nil)
        }
        
        //select a cell
        highlightCell(indexPath, flag: true)
        //puts selected courses into an array
        selectedCourses()
        
        courseCollectionView.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //de select a cell
        highlightCell(indexPath, flag: false)
        
        courseCollectionView.reloadData()
    }
    
    //
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //set sections size to zero if button is tapped
        if sectionsToCollapse.contains(indexPath.section) {
            return CGSize.zero
        }
        //if already collapsed then return to original size
        return defaultItemSize
    }
    
    
}
