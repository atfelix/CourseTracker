//
//  AddCourseViewController.swift
//  CourseTracker
//
//  Created by Rushan on 2017-06-10.
//  Copyright © 2017 Adam Felix. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UISearchBarDelegate{
    
    //temp info
//    let data = DataSource()
    let data = CourseStore()

    //MARK: Properties
    @IBOutlet weak var addButton: UIButton!
    //collectionView
    @IBOutlet weak var courseCollectionView: UICollectionView!
    //searchBar
    @IBOutlet weak var searchBar: UISearchBar!
    var dataSourceForSearchResult:[String]?
    var searchBarActive:Bool = false
    
    //MARK: ViewdidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        courseCollectionView.dataSource = self
        courseCollectionView.delegate = self
        
        
        self.dataSourceForSearchResult = [String]()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let indexPath = getIndexPathForSelectedCell(){
            highlightCell(indexPath, flag: false)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Methods
    //Add button
    @IBAction func addButtonTapped(_ sender: UIButton) {
        
        performSegue(withIdentifier: "ShowCalendar", sender: sender)
    }
    
    func getIndexPathForSelectedCell() -> IndexPath? {
        var indexPath: IndexPath?
        
        if courseCollectionView.indexPathsForSelectedItems!.count > 0 {
            indexPath = courseCollectionView.indexPathsForSelectedItems![0]
        }
        return indexPath
    }
    
    func highlightCell(_ indexPath : IndexPath, flag: Bool) {
        
        let cell = courseCollectionView.cellForItem(at: indexPath)
        
        if flag {
            cell?.contentView.backgroundColor = UIColor.black
        } else {
            cell?.contentView.backgroundColor = nil
        }
    }
    
    //MARK: SearchBar
    func filterContentForSearchText(searchText:String){
//        self.dataSourceForSearchResult = self.data?.filter({ (text:String) -> Bool in
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
                let headerView: DepartmentCollectionReusableView = courseCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! DepartmentCollectionReusableView

                headerView.departmentLabel.text = data.getGroupLabelAtIndex(indexPath.section)
                
                headerView.backgroundColor = UIColor.black
        
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
        
        let name = course.name
        cell.courseLabel.text = name.capitalized
        
        
        //implement search 
        if (self.searchBarActive) {
            cell.courseLabel!.text = self.dataSourceForSearchResult![indexPath.row];
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        highlightCell(indexPath, flag: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        highlightCell(indexPath, flag: false)
    }
    
}
